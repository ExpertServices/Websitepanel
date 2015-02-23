var wsp = {
    messages: new WspMessager('#message-area'),
    fileBrowser: new WspFileBrowser(),
    dialogs: new WspDialogs()
};


$(document).ready(function () {
    $('.processing-dialog').click(function () {
        wsp.dialogs.showProcessDialog();
    });
});

//Toggle file select + Ctrl multiselect
$(document).on('click', '.element-container', function (e) {
    if (e.ctrlKey) {

        $(this).toggleClass("selected-file");

    } else {

        wsp.fileBrowser.clearAllSelectedItems();

        wsp.fileBrowser.selectItem(this);
    }

    wsp.fileBrowser.refreshDeletionBlock();
});

//Double click file open
$(document).on('dblclick', '.element-container', function (e) {
    wsp.fileBrowser.openItem(this);
});


//Delete button click
$(document).on('click', '.file-deletion #delete-button', function (e) {
    var dialogId = $(this).data('target');
    var buttonText = $(this).data('target-positive-button-text');
    var content = $(this).data('target-content');
    var title = $(this).data('target-title-text');

    content = jQuery.validator.format(content, wsp.fileBrowser.getSelectedItemsCount());

    wsp.dialogs.showConfirmDialog(title, content, buttonText, wsp.fileBrowser.deleteSelectedItems, dialogId);
});


$(document).click(function (event) {
    if (!$(event.target).closest('.element-container, .prevent-deselect').length) {
        wsp.fileBrowser.clearAllSelectedItems();
        wsp.fileBrowser.refreshDeletionBlock();
    }
})