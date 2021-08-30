<?php

while (true) {
    $date = date('Y-m-d H:i:s');

    file_put_contents('/var/www/index.txt', $date);
    print $date;
    sleep (10);
}