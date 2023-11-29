$(document).ready(function() {
    $('body').fadeIn();
})



window.addEventListener('message', function(event) {
    if (event.data.type === 'infolar') {
        const avatarURL = event.data.steamfoto;
        const steamName = event.data.isim;
        $(".steamismi").html(steamName);
        $(".steampp").attr("src", avatarURL);
    }
});






window.addEventListener('message', function(event) {
    switch (event.data.type) {
        case 'updateHud':
            updateHud(event.data.data);
            break;
    }
})

function updateHud(data) {
    var healthWidth = (375 * data.health) / 100;
    var armorWidth = (375 * data.armor) / 100;
    var carWidth = (375 * data.carheal) / 1000;
    var gun = new Date();
    var saat = gun.getHours() + ":" + gun.getMinutes();
    var hudBodystamina = document.getElementById("hudBodystamina");
    var counter = document.getElementById("counter");
    $('#canta').html(data.cantakey);
    $('#harita').html(data.mapkey);
    $('#health').css('width', healthWidth + 'px');
    $('#stamina').css('width', data.stamina + '%');
    $('#armor').css('width', armorWidth + 'px');
    $('#carheal').css('width', carWidth + 'px');
    $('#valuetexthealth').html(data.health);
    $('#valuetextcarhealth').html(data.carheal / 2);
    $('#valuetextarmor').html(data.armor);
    $('#clipAmmoDisplay').html(data.clipAmmo);
    $('#totalAmmoDisplay').html(data.totalAmmo);
    $('#kill').html(data.killnumber);
    $('#zaman').html(saat);
    $('#oyuncusayisi').html(data.players);
    $('#oyuncuid').html(data.id);
    $('#userid').html('#' + data.id);
    setTimeout(function() {
        $('#healthlow').css('width', healthWidth + 'px');
        $('#armorlow').css('width', armorWidth + 'px');
    }, 1000);
    var staminaoran = document.getElementById("hudBodystamina");
    var carcan = document.getElementById("hudBodycarheal");
    var mic = document.getElementById("micicon");
    if (data.carheal > 1) {
        carcan.style.opacity = 100;

    } else {
        carcan.style.opacity = 0;

    }
    if (data.konusma === 1) {
        mic.style.animation = "blink 1s ease-in-out infinite";
        mic.style.filter = "invert(30%) sepia(100%) saturate(5707%) hue-rotate(111deg) brightness(93%) contrast(104%)";
        mic.style.opacity = 1;
    } else {
        mic.style.animation = 'none';
        mic.style.opacity = 1;
        mic.style.filter = "invert(22%) sepia(49%) saturate(3111%) hue-rotate(344deg) brightness(92%) contrast(83%)";
    }

    if (data.stamina === 100 || data.arabadami == true) {
        hudBodystamina.style.opacity = 0;
        setTimeout(function() {
            document.getElementById("StaminaHud").style.marginTop = "0px";
            document.getElementById("staminaicon").style.opacity = 0;
            
        }, 1);
    } else if (data.stamina <= 25) {
        staminaoran.style.opacity = 1;
        staminaoran.style.animation = "blink 1s ease-in-out infinite";
        document.getElementById("staminaicon").style.opacity = 100;
    } else {
        document.getElementById("StaminaHud").style.marginTop = "18px";
        document.getElementById("staminaicon").style.width = "28px";
        hudBodystamina.style.opacity = 100;
        staminaoran.style.animation = 'none'
        document.getElementById("staminaicon").style.opacity = 100;
    }
    if (data.weapon === -1569615261 || data.weapon === -1834847097 || data.weapon === -1786099057 || data.weapon === -102323637 || data.weapon === 2067956739 || data.weapon === -1951375401 || data.weapon === 1141786504 || data.weapon === 1317494643 || data.weapon === -102973651 || data.weapon === -656458692 || data.weapon === -1716189206 || data.weapon === -581044007 || data.weapon === -538741184 || data.weapon === 1737195953 || data.weapon === 419712736 || data.weapon === -853065399 || data.weapon === -1810795771 || data.weapon === 940833800 || data.weapon === -72657034) {
        counter.style.opacity = 0;
    } else {
        counter.style.opacity = 100;
    }



}