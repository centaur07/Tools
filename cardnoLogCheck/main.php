<?php
ini_set('memory_limit', '256M');
require_once('vendor/autoload.php');

use app\library\File;
use app\library\ReportParser;
use app\library\Output;

// Arrange
$fileExt = 'txt';
$ignoreFileExt = 'txt';
$ignoreListDirPath = './ignoreList';
$checkList = array();
$file = new File();
$parser = new ReportParser($file);
unset($file);

// Get the server name
Output::display('Card number log check', false);
Output::display('Please enter the server name:', false);
Output::display('(Press "enter" to check all server in ignore list)', false);
$input = fgets(STDIN);
$serverName = trim($input, "\r\n");
unset($input);

// Get the report types
if ($serverName === '') {
    // Scan the ignore list
    Output::display('Scan the ignore list', false);
    if (file_exists($ignoreListDirPath)) {
        $scanPath = $ignoreListDirPath . '/*.' . $ignoreFileExt;
        $result = glob($scanPath);
        unset($scanPath);
    } else {
        Output::display($ignoreListDirPath . ' does not exist', false);
        exit;
    }

    // Check the list
    if (count($result) === 0) {
        Output::display($ignoreListDirPath . ' is empty, please create the ignore list file!', false);
        exit;
    } else {
        // Set the check list
        foreach ($result as $row) {
            array_push($checkList, basename($row, '.' . $ignoreFileExt));
        }
    }
    unset($result);
} else {
    array_push($checkList, $serverName);
}
unset($serverName);
Output::display('----------------------------------------------------', false);

foreach ($checkList as $reportType) {
    // Scan the folder and get the log
    Output::display('Scan the "*.' . $fileExt . '" from "' . $reportType . '" folder', false);
    $dirPath = './file/' . $reportType;
    $logPath = $dirPath . '/*.' . $fileExt;
    if (file_exists($dirPath)) {
        $files = glob($logPath);
        unset($logPath);
    } else {
        Output::display($dirPath . ' does not exist', false);
        exit;
    }

    // Get the ignore list
    $ignoreListFilePath = $ignoreListDirPath . '/' . $reportType . '.txt';
    if (file_exists($ignoreListFilePath)) {
        $ignoreList = $parser->getReport($ignoreListFilePath);
        unset($ignoreListFilePath);
    } else {
        Output::display($ignoreListFilePath . ' does not exist', false);
        exit;
    }


    // Check the content
    foreach ($files as $filePath) {
        Output::display('Checking the file ' . $filePath, false);
        $result = $parser->getReportWithout($filePath, $ignoreList);
        if (count($result) > 0) {
            Output::display('These file could have card number:', false);
            Output::display($result, false);
        } else {
            Output::display('Pass!!', false);
        }
    }
    Output::display('----------------------------------------------------', false);
}