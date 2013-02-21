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

    public function fetch( $args ) {
        $tpl = templateInit();
        $tpl->setVariable( 'name', $value );
        return $tpl->fetch( 'design:node/view/full.tpl' );
        //return json_encode(array('message'=>$args));
    }

    public static function latest( $args ) {
        $ch = curl_init("http://ordnett.no/siste");
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_BINARYTRANSFER, true);
        $content = curl_exec($ch);
        curl_close($ch);
        return $content;
    }
    public static function produkt_info( $args ) {
        if (isset($args[0])){
            $var1 = htmlspecialchars($args[0]);
        }
        $json_object = json_encode(array('isbn'=>$var1,'butikkId'=>'MP','sharedsecret'=>'hulahula'));
        $ch = curl_init("http://www.bokkilden.no/SamboWeb/REST/produktinfo.do?data=".$json_object);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_BINARYTRANSFER, true);
        $content = curl_exec($ch);
        curl_close($ch);
        $dekodet = json_decode($content);
        return $dekodet;
    }

    public static function getCacheTime( $functionName ) {
        return time();
    }
}

?>
