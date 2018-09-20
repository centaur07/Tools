<?php
namespace app\library;

final class Output
{
    /**
     * Display the content
     * @param  string    $content     Content
     * @param  bool      $withDate    Display with date
     * @return void
     */
    public static function display($content, $withDate = true)
    {
        if ($withDate === true) {
            echo date('Y-m-d H:i:s') . '    ';
        }
        echo print_r($content, true) . PHP_EOL;
    }
}