function recalculateResourseHeight() {
    $(document).ready(function () {
        var heights = $(".element-container").map(function () {
            return $(this).height();
        }).get(),

            maxHeight = Math.max.apply(null, heights);

        $(".element-container").height(maxHeight);
    });
}
