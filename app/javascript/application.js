// Entry point for the build script in your package.json
import Rails from "@rails/ujs";

import "./bootstrap";
import "./highcharts";
import "./jquery";
import "./moment";

import "bootstrap-select";
import "chartkick";
import "daterangepicker";

Rails.start();

$(function () {
    $(".bs-select").selectpicker({
        deselectAllText: "Izberi nic",
        iconBase: "bi",
        liveSearchNormalize: true,
        noneResultsText: "Nema nic podobnega {0}",
        selectAllText: "Izberi vse",
        selectedTextFormat: "count > 3",
        style: "",
        styleBase: "form-control",
        tickIcon: "bi-check2",
        width: "auto"
    });

    $(".drp-input").daterangepicker({
        alwaysShowCalendars: true,
        autoUpdateInput: false,
        linkedCalendars: false,
        showCustomRangeLabel: false,
        showDropdowns: true,

        locale: {
            applyLabel: "Izberi",
            cancelLabel: "Pocisti",
            format: "DD.MM.YYYY"
        },

        ranges: {
            "Danes": [moment(), moment()],
            "Vceraj": [moment().subtract(1, "days"), moment().subtract(1, "days")],
            "Zadnjih 7 dni": [moment().subtract(6, "days"), moment()],
            "Zadnjih 30 dni": [moment().subtract(29, "days"), moment()],
            "Ta mesec": [moment().startOf("month"), moment().endOf("month")],
            "Prejsnji mesec": [moment().subtract(1, "month").startOf("month"),
                               moment().subtract(1, "month").endOf("month")],
            "Vekomaj": [moment(0), moment()]
        }
    })
        .on("apply.daterangepicker", function(ev, picker) {
            // extracted from DateRangePicker#updateElement to compensate for !autoUpdateInput
            var newValue = picker.startDate.format(picker.locale.format);
            if (!picker.singleDatePicker) {
                newValue += picker.locale.separator + picker.endDate.format(picker.locale.format);
            }
            if (newValue !== picker.element.val()) {
                picker.element.val(newValue).trigger("change");
            }
        })
        .on("cancel.daterangepicker", function(ev, picker) {
            picker.element.val("").trigger("change");
        });
});
