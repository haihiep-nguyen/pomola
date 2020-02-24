$(document).ready(function () {
    console.log("READY");
    $(document).on('submit', '#command-form', function () {
        $('#command-form input').val('');
    })
});