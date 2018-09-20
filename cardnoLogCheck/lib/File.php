<?php
namespace app\library;

class File
{
    /**
     * Read a file by "generator"
     * @param  string    $path    File path
     * @return void
     */
    public static function readRows($path)
    {
        $handle = fopen($path, 'r');
        try {
            while (!feof($handle)) {
                $row = fgets($handle);
                yield $row;
            }
        } finally {
            fclose($handle);
        }
    }
}