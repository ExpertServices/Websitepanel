var processDialog;
processDialog = processDialog || (function () {
    var processDialogDiv = $('#processDialog');
    return {
        showPleaseWait: function () {
            $('#processDialog').modal();
        },
        hidePleaseWait: function () {
            $('#processDialog').modal('hide');
        },

    };
})();


$(document).ready(function() {
    $('.processing-dialog').click(function () {
        processDialog.showPleaseWait();
    });
});