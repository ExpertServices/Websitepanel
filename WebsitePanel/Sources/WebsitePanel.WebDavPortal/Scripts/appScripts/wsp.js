var wsp = {
    messages: new WspMessager('#message-area'),
    fileBrowser: new WspFileBrowser(),
    dialogs: new WspDialogs()
};


$(document).on('click', '.processing-dialog', function (e) {
    wsp.dialogs.showProcessDialog();
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

$(document).on('touchstart', '.element-container', function(e) {
    var now = new Date().getTime();
    var lastTouch = $(this).data('lastTouch') || now + 1;
    var delta = now - lastTouch;

    if (delta < 300 && delta > 0) {
        wsp.fileBrowser.openItem(this);
        $(this).data('lastTouch', 0);
    }

    $(this).data('lastTouch', now);
});

//Double click file open
$(document).on('dblclick', '.element-container', function (e) {
    wsp.fileBrowser.openItem(this);

    var links = $(item).find('.file-link');

    if (links.length != 0 && links[0].hasClass('processing-dialog')) {
        wsp.dialogs.showProcessDialog();
    }
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


$(document).click(function(event) {
    if (!$(event.target).closest('.element-container, .prevent-deselect').length) {
        wsp.fileBrowser.clearAllSelectedItems();
        wsp.fileBrowser.refreshDeletionBlock();
    }
});

$('#drag-and-drop-area').click(function (e) {
    $('#file-input').click();
});

$('#drag-and-drop-area #file-input').click(function (e) {
    e.stopPropagation();
});


function isMobileDevice() {
    return (/android|webos|iphone|ipad|ipod|blackberry|iemobile|opera mini/i.test(navigator.userAgent.toLowerCase()));
}

