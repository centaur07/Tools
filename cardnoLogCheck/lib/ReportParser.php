<?php
namespace app\library;
use app\library\Output; // test

final class ReportParser
{
    private $file = null;

    public function __construct($file)
    {
        $this->file = $file;
    }

    /**
     * Get the report
     * @param  string    $path    Report txt path
     * @return array              Report data
     */
    public function getReport($path)
    {
        $report = array();
        $rows = $this->file->readRows($path);
        foreach ($rows as $row) {
            $trimmed = trim($row, "\r\n");
            if (!empty($trimmed)) {
                $report[] = $trimmed;
            }
            unset($current, $trimmed);
        }

        return $report;
    }

    /**
     * Get the item type
     * @param  string    $row    The row of report
     * @return string            Type
     */
    public function getItemType($row)
    {
        $type = '';
        $pieces = explode('\Path', $row);

        if (count($pieces) > 1) {
            $type = $pieces[0];
        }

        return $type;
    }

    /**
     * Get the file path
     * @param  string    $row    The row of report
     * @return string            File path
     */
    public function getFilePath($row)
    {
        // Get the file path
        $substrCount = substr_count($row, '.php');
        $trimmed = trim($row);
        $path = str_replace('File Name ', '', $trimmed);

        return $path;
    }

    /**
     * Get the report item info
     * @param  string    $path    The report path
     * @return array              Info
     */
    public function getItemInfo($path)
    {
        // Arrange
        $data = array();
        $startMark = 'Code Snippet';
        $startFlag = false;
        $endMark = 'Method';
        $rows = $this->getReport($path);
        $type = '';
        $description = '';

        foreach($rows as $row) {
            if (empty($type)) {
                // Get the item description
                $description = $row;
                $type = $this->getItemType($description);
            } else {
                if ($startFlag === false) {
                    $pieces = substr($row, 0, strlen($startMark));
                    if ($pieces === $startMark) {
                        // Start to detected
                        $startFlag = true;
                    }
                    unset($pieces);
                } else {
                    $path = $this->getFilePath($row);
                    if (!empty($path)) {
                        // Set the info
                        $data[] = compact(array('type', 'description', 'path'));

                        // Reset
                        $startFlag = false;
                        $description = '';
                        $type = '';
                    }
                }
            }
        }

        return $data;
    }

    /**
     * Get the report without specific content
     * @param  string    $path          The report path
     * @param  array     $ignoreList    The ignore list
     * @return array                    Report
     */
    public function getReportWithout($path, $ignoreList)
    {
        $report = array();
        $rows = $this->getReport($path);

        foreach ($rows as $row) {
            // Check the ignore list
            $isMatch = false;
            foreach ($ignoreList as $piece) {
                if (substr_count($row, $piece) > 0) {
                    $isMatch = true;
                    continue;
                }
            }
            if ($isMatch === false) {
                array_push($report, $row);
            }
        }

        return $report;
    }
}