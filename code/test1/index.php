<?php

echo 'test 111111111111111';

echo '<pre>';
#print_r($_SERVER);
print_r($_ENV);
print_r(file_get_contents('/secrets/file.env'));