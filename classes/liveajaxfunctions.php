<?php

//include_once( 'kernel/classes/ezcontentobjecttreenode.php' );

class LiveAjaxFunctions extends ezjscServerFunctions {

    public function add_content( $args ) {
        if(isset($_POST['nonce'])) {
            session_start();
            if($_POST['nonce'] !=  $_SESSION['live_nonce']) {
                die('Your are busted!');
            }
                
            $return = array();
            $user =& eZUser::currentUser();

            if( isset($_POST['text']) && strlen($_POST['text'])> 1 && isset($_POST['name']) && strlen($_POST['name']) > 1 && isset($_POST['parent_id']) && strlen($_POST['parent_id']) > 0 ) {
                
                $class_identifier = "live_status";
                $text =  strip_tags($_POST['text']);
                $node_name = substr ( $text , 0 , 18 ) . "..";
                if($user->ContentObjectID == 10) {
                    $username = strip_tags($_POST['name']);
                    $class_identifier = "live_question";
                } 
                
                $login_name = $user->attribute( 'login' );
                $parent_id = $_POST['parent_id'];
                $parent_node = eZFunctionHandler::execute('content','node', array('node_id' => $parent_id) );

                $class  =& eZContentClass::fetchByIdentifier( $class_identifier );
                $object =& $class->instantiate( $user->ContentObjectID, $parent_node->ContentObject->SectionID );
                $nodeAssignment =& eZNodeAssignment::create(
                    array(  
                        'contentobject_id' => $object->attribute( 'id' ),
                        'contentobject_version' => $object->attribute( 'current_version' ),
                        'parent_node' => $parent_node->MainNodeID,
                        'sort_field' => 2,
                        'sort_order' => 0,
                        'is_main' => 1
                    )
                );
                $nodeAssignment->store();

                $version =& $object->version( 1 );
                $version->setAttribute( 'status', EZ_VERSION_STATUS_DRAFT );
                $version->store();
                $object->setAttribute( 'name', $node_name);

                $dataMap =& $version->dataMap();
                $dataMap['text']->setAttribute( 'data_text', $text );
                $dataMap['text']->store();
                if($user->ContentObjectID == 10) {
                    $dataMap['name']->setAttribute( 'data_text', $username );
                    $dataMap['name']->store();
                } 
                $object->store();

                // publish content object
                if( $operationResult = eZOperationHandler::execute( 'content', 'publish', 
                    array( 
                        'object_id' => $object->attribute( 'id' ),
                        'version' => $object->attribute('current_version') 
                    ) 
                ) ) {
                    if($user->ContentObjectID == 10) {
                        $return = array('message' => "Your question was added!");
                    } else {
                        $return = array('message' => "Your status was added!");
                    }
                } else {
                    $return = array('error' => "Not able to publish your question");
                }
            } else {
                $return['error'] = "Missing username or message";
            }

            header('Content-type: application/json');
            return json_encode($return);

        } else {
            die('Missing nonce');
        }
    }
    public function updates_count ( $args ) {
        $node_id = $args[0];
        $ts = $args[1];
        $ini = eZINI::instance( 'liveevent.ini' );
        $classes = $ini->variable( 'Content' , 'Classes' );
        $node_count = eZFunctionHandler::execute('content','list_count', 
            array(
                'parent_node_id' => $node_id,
                'class_filter_type' => 'include',
                'class_filter_array' => $classes,
                'attribute_filter' => array(
                    array( 'published', '>', $ts )
                )
            )
        );
        header('Content-type: application/json');
        return json_encode(array('updates'=>$node_count));
    }

    public function comments_count ( $args ) {
        $contentobject_id = $args[0];
        $comments_count = eZFunctionHandler::execute('comment','comment_count', 
            array(
                'contentobject_id' => $contentobject_id,
                'status', 1
            )
        );
        header('Content-type: application/json');
        return json_encode(array('comments_count'=>$comments_count));
    }



    /*
    public function fetch( $args ) {
        $node_id = $args[0];
        $node = $parent_node = eZFunctionHandler::execute('content','node', array('node_id' => $node_id) );
        $tpl = eZTemplate::factory();;
        $tpl->setVariable( 'node', $node );
        return $tpl->fetch( 'design:node/view/full.tpl' );
    }*/

}

?>
