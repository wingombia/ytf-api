$(document).ready(() => {
    $("#size").on("change", () => {
        let size = $(event.target).val()
        let url = `http://localhost:3000/api/get?font=Purisa&text=ABCDEFGHJKLMNOPQRSTUVWXYZ123456789&size=${size}`
        $.ajax({
            url: url,
            type: 'get',
            success: (data,status,xhr) => {
                $("#display").css("background-image","url(" + data.url + ")")
                
            }
        })
    })
})