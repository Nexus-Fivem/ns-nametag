window.addEventListener('message', function(event) {
    const data = event.data;
    if (data.type === 'updateNametags') {
        const root = document.querySelector('.root');
        root.innerHTML = '';
        if (data.players && Array.isArray(data.players)) {
            data.players.forEach(player => {
                const nametagContainer = document.createElement('div');
                nametagContainer.classList.add('nametag_container');
                var nametag = null
                if (player.isAdmin) {
                 nametag = `
                    <div class="nametag" style="transform: scale(${player.scale})">
                        <div style="background-color: rgb(236, 63, 71); color: white;" class="nametag_playerid">${player.playerId}</div>
                        <div class="nametag_playername" style="border: 3px solid rgb(236, 63, 71);">${player.playerName} <i class="fa-solid fa-crown" style="color: rgb(236, 63, 71);"></i></div>
                        <div class="nametag_triangle"></div>
                    </div>
                `;
                } else if (player.isMod) {
                    nametag = `
                    <div class="nametag" style="transform: scale(${player.scale})">
                        <div style="background-color: rgb(43, 107, 245); color: white;" class="nametag_playerid">${player.playerId}</div>
                        <div class="nametag_playername" style="border: 3px solid rgb(43, 107, 245);">${player.playerName} <i class="fa-solid fa-shield-halved" style="color: rgb(43, 107, 245);"></i></div>
                        <div class="nametag_triangle"></div>
                    </div>
                `;  
                } 
                else {
                     nametag = `
                        <div class="nametag" style="transform: scale(${player.scale})">
                            <div class="nametag_playerid">${player.playerId}</div>
                            <div class="nametag_playername">${player.playerName} <i class="fa-solid fa-globe"></i></div>
                            <div class="nametag_triangle"></div>
                        </div>
                    `; 
                }
                nametagContainer.innerHTML = nametag;
                nametagContainer.style.left = `${player.screenX * 100}%`;
                nametagContainer.style.top = `${player.screenY * 100}%`;
                root.appendChild(nametagContainer);
            });
        } else {
            console.error("Player listesi bulunamadı.");
        }
    }
});
