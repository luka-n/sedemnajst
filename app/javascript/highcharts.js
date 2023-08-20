import Highcharts from "highcharts";

Highcharts.setOptions({
    lang: {
        resetZoom: "Odzoomaj",
        resetZoomTitle: "Odzoomaj",

        months: [
            "Januar", "Februar", "Marec", "April", "Maj", "Junij", "Julij",
            "Avgust", "September", "Oktober", "November", "December"
        ],

        shortMonths: [
            "Jan", "Feb", "Mar", "Apr", "Maj", "Jun", "Jul", "Avg", "Sep",
            "Okt", "Nov", "Dec"
        ],

        weekdays: [
            "Nedelja", "Ponedeljek", "Torek", "Sreda", "Cetrtek", "Petek",
            "Sobota"
        ]
    }
});

window.Highcharts = Highcharts;
