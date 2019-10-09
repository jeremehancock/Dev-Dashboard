<!DOCTYPE html>
<html lang="en">
<?php

/* Include GitHub Config*/
require_once("config/github-config.php");

$picheck = 'config/pizero';

if (file_exists($picheck)) {
    $dev_env = "Pi Zero Dev";
    $base = "html";
    $icon = "pizero-favicon.ico";
    $poweredby = "raspberrypi.png";
} else {
    $dev_env = "Vagrant Dev";
    $base = "html";
    $icon = "vagrant-favicon.ico";
    $poweredby = "vagrant.png";
}

if (basename(dirname(__FILE__)) == $base) {
    $title = "Projects";
} else {
    $title = ucfirst(str_replace("*", "", basename(dirname(__FILE__))));
}

// Function to check string starting
// with given substring
function startsWith($string, $startString)
{
    $len = strlen($startString);
    return (substr($string, 0, $len) === $startString);
}

?>
<head>
    <meta charset="UTF-8">
    <title><?php echo $dev_env . ": " . $title; ?></title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="../.css/style.css">
    <link rel="shortcut icon" href="../.images/<?php echo $icon; ?>"/>
    <style>html {overflow-y: scroll;}</style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.2/css/all.css">
</head>
<body>

<?php
// Hide dot files
$hide = ".";
?>
<header role="banner" class="header">
    <img src="../.images/<?php echo $poweredby; ?>" class="poweredby"/>
    <h1><?php echo $dev_env . ": " . $title; ?></h1>
</header>

<div class="divTable">
    <div class="divTableBody">
        <div class="divTableRow">
            <div class="divTableCell header-name">Name</div>
            <div class="divTableCell header-date">Date Modified</div>
        </div>

        <?php

        // Opens directory
        $myDirectory = opendir(".");

        // Gets each entry
        while ($entryName = readdir($myDirectory)) {
            $dirArray[] = $entryName;
        }

        // Closes directory
        closedir($myDirectory);

        // Counts elements in array
        $indexCount = count($dirArray);

        // Sorts files
        sort($dirArray);

        // Loops through the array of files
        for ($index = 0; $index < $indexCount; $index++) {

            // Decides if hidden files should be displayed, based on query above.
            if (substr("$dirArray[$index]", 0, 1) != $hide) {

                // Resets Variables
                $favicon = "";
                $class = "file";

                // Gets File Names
                $name = $dirArray[$index];
                $namehref = $dirArray[$index];

                // Gets Date Modified
                $modtime = date("M j, Y, g:i A", filemtime($dirArray[$index]));
                $timekey = date("YmdHis", filemtime($dirArray[$index]));

                // Separates directories, and performs operations on those directories
                if (is_dir($dirArray[$index])) {

                    $extn = "Folder";
                    $size = "--";
                    $sizekey = "0";
                    $class = "dir";

                    // Gets favicon.png, and displays it, only if it exists.
                    if (file_exists("$namehref/favicon.png")) {
                        $favicon = "$namehref/favicon.png";
                        $extn = "Website";
                    } elseif (file_exists("$namehref/favicon.ico")) {
                        $favicon = "$namehref/favicon.ico";
                        $extn = "Website";
                    } else {
                        $favicon = "../.images/default.ico";
                        $extn = "Website";
                    }

                }
                // Output - only display directories
                if ($class == "dir" && $name != "config") {
                    $name = str_replace("_", "'", str_replace(".php", "", str_replace("-", " ", $name)));
                    if ((startsWith($name, "*"))) {
                        $name = ucfirst(str_replace("*", "", $name));
                    }

                    if ($index % 2 == 0) {
                        $colorclass = "even";
                    } else {
                        $colorclass = "odd";
                    }

                    if ($name == "Back") {
                        $newtab = "nonewtab";
                    }
                    else {
                        $newtab = "newtab";
                    }

                    echo("
                    <div class='divTableRow'>
                        <div class='divTableCell $colorclass name'>
                            <a href='javascript:void(0)' onClick=\"window . open('./$namehref/?t=' + (new Date() . getTime()), '_top');\">
                                <img class='favicon' src='$favicon'/>
                                $name
                            </a>
                             <a href='javascript:void(0)' title='Open In New Tab' onClick=\"window . open('./$namehref/?t=' + (new Date() . getTime()), '_blank');\">
                                  <span class='$newtab'><i class=\"fas fa-external-link-square-alt\"></i></span>
                              </a>
                        </div>
                        <div class='divTableCell $colorclass date'>$modtime</div>
                    </div>"
                    );

                }
            }
        }
        ?>

    </div>
</div>
<a href="https://github.com/<?php echo $github_user; ?>?tab=repositories" target="_blank"><img src="../.images/github.png" class="github"/></a>
</body>
</html>
