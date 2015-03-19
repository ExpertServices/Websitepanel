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
            "processing": false,
            "serverSide": true,
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
            },
            "fnPreDrawCallback": function () {
                // gather info to compose a message
                wsp.dialogs.showProcessDialog();
                return true;
            },
            "fnDrawCallback": function () {
                // in case your overlay needs to be put away automatically you can put it here
                wsp.dialogs.hideProcessDialog();
            }
        });

        $(tableId).removeClass('dataTable');

        var oTable = this.table;
        $(tableId+'_filter input').unbind();
        $(tableId+'_filter input').bind('keyup', function (e) {
            if (e.keyCode == 13) {
                oTable.fnFilter(this.value);
            }
        });
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
    },

    initBigIcons: function (elementId, url) {
        $(document).ready(function () {
            $(window).load(function () {
                getResources();
            });
            $(window).scroll(function () {
                if (($(window).scrollTop() + 1) >= ($(document).height() - $(window).height())) {
                    getResources();
                };
            });
        });

        var oldResourcesDivHeight = $(elementId).height();

        function getResources() {
            $.ajax({
                type: 'POST',
                url: url,//'/storage/show-additional-content',
                data: { path: window.location.pathname, resourseRenderCount: $(".element-container").length },
                dataType: "html",
                success: function (result) {
                    var domElement = $(result);
                    $(elementId).append(domElement);
                    if ($(document).height() == $(window).height() && oldResourcesDivHeight != $('#resourcesDiv').height()) {
                        getResources();
                        oldResourcesDivHeight = $(elementId).height();
                    };

                    recalculateResourseHeight();
                }
            });
        };
    }
};














