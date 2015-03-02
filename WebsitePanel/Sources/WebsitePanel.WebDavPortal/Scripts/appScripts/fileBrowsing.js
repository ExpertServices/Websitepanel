function WspFileBrowser() {
    this.settings = { deletionBlockSelector: ".file-actions-menu .file-deletion", deletionUrl: "storage/files-group-action/delete" };
    this.table = null;
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
                wsp.fileBrowser.refreshDataTable();

                wsp.dialogs.hideProcessDialog();
            },
            error: function (jqXHR, textStatus, errorThrown) {
                wsp.messages.addErrorMessage(errorThrown);

                wsp.fileBrowser.refreshDeletionBlock();
                wsp.fileBrowser.refreshDataTable();

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
    },

    initDataTable: function (tableId, ajaxUrl) {
        this.table = $(tableId).dataTable({
            "ajax": ajaxUrl,
            "processing": true,
            "serverSide": true,
            "searching": false,
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        return '<img class="table-icon" src="' + row.IconHref + '"/>' +
                            '<a href="' + row.Url + '" ' + (row.IsTargetBlank ? 'target="_blank"' : '') + ' class="file-link ' + (row.IsFolder ?  'processing-dialog':'') + '" title="' + row.DisplayName + '">' +
                                    row.DisplayName +
                                '</a>';
                    },
                    "targets": 0
                },
                {
                    "render": function (data, type, row) {
                        return row.Type;
                    },
                    "orderable": false,
                    "className": "center",
                    "width":"10%",
                    "targets": 1
                },
                {
                    "render": function (data, type, row) {
                        return row.LastModifiedFormated;
                    },
                    "width": "20%",
                    "className": "center",
                    "targets": 2
                }
            ],
            "createdRow": function(row, data, index) {
                $(row).addClass('element-container');
            }
        });

        $(tableId).removeClass('dataTable');
    },

    refreshDataTable: function () {
        if (this.table != null) {
            this.table.fnDraw(false);
        }
    },

    initFileUpload: function (elementId, url) {
        $(document).ready(function () {

            $(elementId).fileupload({ url: url, autoUpload: true });

            $(elementId).fileupload('option', {
                disableImagePreview: true,
                sequentialUploads: true
            });
        });
    }
};














