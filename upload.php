<?php 
 if(isset($_POST['upload_image'])) {
        if(file_put_contents("img/".time().".png", base64_decode($_POST['thumbnail']))) {
            echo "Success"; 
        } 
    }

?>
