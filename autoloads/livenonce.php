<?php


class LiveNonce
{
    function LiveNonce()
    {
    }

    function operatorList()
    {
        return array( 'nonce' );
    }

    function namedParameterPerOperator()
    {
        return true;
    }

    function namedParameterList()
    {
        return array();
    }

    function modify( $tpl, $operatorName, $operatorParameters, &$rootNamespace, &$currentNamespace, &$operatorValue, &$namedParameters )
    {
        session_start();
        if(!isset($_SESSION['live_nonce']))
            $_SESSION['live_nonce']=md5(mktime());
        $operatorValue =  $_SESSION['live_nonce'];
    }
}

?>
