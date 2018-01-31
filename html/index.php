<?php
$script_name = basename(__FILE__);
foreach(scandir('.') as $file) {
  if ($file[0] !== '.' && $file !== $script_name) {
    echo $file.' - Read bytes: '.strlen(file_get_contents($file)).'<br>';
  }
}
