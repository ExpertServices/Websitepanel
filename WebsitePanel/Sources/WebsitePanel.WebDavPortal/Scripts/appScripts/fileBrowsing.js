function WspFileBrowser() {
    this.settings = { deletionBlockSelector: ".file-actions-menu .file-deletion", deletionUrl: "files-group-action/delete1" };
}

WspFileBrowser.prototype = {
    setSettings: function(options) {
        this.settings = $.extend(this.settings, options);
    },

    clearAllSelectedItems: function() {
        $('.element-container').removeClass("selected-file");
    },

    selectItem: function(item) {
        $(item).addClass("selected-file");
    },

    openItem: function(item) {
        var links = $(item).find('.file-link');

        if (links.length != 0) {
            links[0].click();
        }
    },

    getSelectedItemsCount: function() {
        return $('.element-container.selected-file').length;
    },

    getSelectedItemsPaths: function() {
        return $('.element-container.selected-file a').map(function() {
            return $(this).attr('href');
        }).get();
    },

    deleteSelectedItems: function(e) {
        $.ajax({
            type: 'POST',
            url: wsp.fileBrowser.settings.deletionUrl,
            data: { filePathes: wsp.fileBrowser.getSelectedItemsPaths() },
            dataType: "json",
            success: function(model) {
                wsp.messages.showMessages(model.Messages);

                wsp.fileBrowser.clearDeletedItems(model.DeletedFiles);

                wsp.fileBrowser.refreshDeletionBlock();

                wsp.dialogs.hideProcessDialog();
            },
            error: function(jqXHR, textStatus, errorThrown) {
                wsp.messages.addErrorMessage(errorThrown);
                wsp.fileBrowser.refreshDeletionBlock();
                wsp.dialogs.hideProcessDialog();
            }
        });

        wsp.dialogs.showProcessDialog();
    },

    clearDeletedItems: function(items) {
        $.each(items, function(i, item) {
            $('.element-container').has('a[href="' + item + '"]').remove();
        });
    },
    refreshDeletionBlock: function() {
        if (this.getSelectedItemsCount() > 0) {

            $(this.settings.deletionBlockSelector).css('display', 'inline-block');

        } else {
            $(this.settings.deletionBlockSelector).hide();
        }
    }
};














