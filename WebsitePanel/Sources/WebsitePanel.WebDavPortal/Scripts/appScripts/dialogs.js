function WspDialogs() {
    this.settings = { dialogId: "#confirm-dialog", processDialogId: "#processDialog" };
}

WspDialogs.prototype =
{
    showConfirmDialog: function(title, content, positiveButton, positiveClickFunction, dialogId) {
        dialogId = dialogId || this.settings.dialogId;

        //title replace
        if (title) {
            $(dialogId).find('.modal-title').empty();
            $(dialogId).find('.modal-title').text(title);
        }

        //body replace
        $(dialogId).find('.modal-body').empty();
        $(dialogId).find('.modal-body').html(content);

        //positive button replace
        if (positiveButton) {
            $(dialogId).find('.modal-footer .positive-button').empty();
            $(dialogId).find('.modal-footer .positive-button').text(positiveButton);
        }

        //binding click event
        $(dialogId).find('.modal-footer .positive-button').unbind('click');
        $(dialogId).find('.modal-footer .positive-button').click(positiveClickFunction);

        $(dialogId).modal();
    },

    showProcessDialog: function() {
        $(this.settings.processDialogId).modal();
    },

    hideProcessDialog: function() {
        $(this.settings.processDialogId).modal('hide');
}
};

