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

    var links = $(this).find('.file-link');

    if (links.length != 0 && $(links[0]).hasClass('processing-dialog')) {
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



$("#create-button").click(function (e) {

    if ($('#filenameForm').valid()) {

        var fileName = $('#createNewItemDialog #filename').val() + $(this).data('extension');

        $(this).attr('href', $(this).data('href') + '/' + fileName);

        $(this).attr('target', $(this).data('target'));

        wsp.fileBrowser.hideCreateNewItemDialog();
        //;
    } else {
        e.preventDefault();
    }
});

$.fn.clearValidation = function () { var v = $(this).validate(); $('[name]', this).each(function () { v.successList.push(this); v.showErrors(); }); v.resetForm(); v.reset(); $(this).find('.form-group').removeClass('has-error'); };

$(document).ready(function() {
    //bootstrap jquery validate styles fix
    $.validator.setDefaults({
        highlight: function(element) {
            $(element).closest('.form-group').addClass('has-error');
        },
        unhighlight: function(element) {
            $(element).closest('.form-group').removeClass('has-error');
        },
        errorElement: 'span',
        errorClass: 'help-block',
        errorPlacement: function(error, element) {
            if (element.parent('.input-group').length) {
                error.insertAfter(element.parent());
            } else {
                error.insertAfter(element);
            }
        }
    });

    $.validator.addMethod("synchronousRemote", function (value, element, param) {
        if (this.optional(element)) {
            return "dependency-mismatch";
        }

        var previous = this.previousValue(element);
        if (!this.settings.messages[element.name]) {
            this.settings.messages[element.name] = {};
        }
        previous.originalMessage = this.settings.messages[element.name].remote;
        this.settings.messages[element.name].remote = previous.message;

        param = typeof param === "string" && { url: param } || param;

        if (previous.old === value) {
            return previous.valid;
        }

        previous.old = value;
        var validator = this;
        this.startRequest(element);
        var data = {};
        data[element.name] = value;
        var valid = "pending";
        $.ajax($.extend(true, {
            url: param,
            async: false,
            mode: "abort",
            port: "validate" + element.name,
            dataType: "json",
            data: data,
            success: function (response) {
                validator.settings.messages[element.name].remote = previous.originalMessage;
                valid = response === true || response === "true";
                if (valid) {
                    var submitted = validator.formSubmitted;
                    validator.prepareElement(element);
                    validator.formSubmitted = submitted;
                    validator.successList.push(element);
                    delete validator.invalid[element.name];
                    validator.showErrors();
                } else {
                    var errors = {};
                    var message = response || validator.defaultMessage(element, "remote");
                    errors[element.name] = previous.message = $.isFunction(message) ? message(value) : message;
                    validator.invalid[element.name] = true;
                    validator.showErrors(errors);
                }
                previous.valid = valid;
                validator.stopRequest(element, valid);
            }
        }, param));
        return valid;
    }, "Please fix this field.");


    $('#filenameForm').validate({
        onkeyup: false,
        onclick: false,
        async: false,
        rules: {
            filename: {
                required: true,
                synchronousRemote: wsp.fileBrowser.uniqueFileNameFieldRule("#filename")
            }
        },
        messages: {
            filename: {
                synchronousRemote: wsp.fileBrowser.settings.textItemExist
            }
        }
    });

});


$(".create-new-item li a").click(function () {

    $("#filenameForm").clearValidation();

    wsp.fileBrowser.showCreateNewItemDialog($(this).data('extension'), $(this).data('target'));

    $("#filename").focus();
});


function isMobileDevice() {
    return (/android|webos|iphone|ipad|ipod|blackberry|iemobile|opera mini/i.test(navigator.userAgent.toLowerCase()));
}

