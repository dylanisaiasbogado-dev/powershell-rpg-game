# ============================================
# PowerShell RPG Game - VERSIÓN SIMPLE
# ============================================

# Variables globales del jugador
$jugador = @{
    nombre = ""
    nivel = 1
    experiencia = 0
    vidaMaxima = 100
    vida = 100
    mana = 50
    fuerza = 10
    defensa = 5
    oro = 100
    inventario = @{}
}

# Función para mostrar el menú principal
function Mostrar-MenuPrincipal {
    Clear-Host
    Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║        🎮 POWERSHELL RPG ADVENTURE 🎮     ║" -ForegroundColor Cyan
    Write-Host "║                                            ║" -ForegroundColor Cyan
    Write-Host "║        Bienvenido al mundo del RPG         ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

# Función para crear el personaje
function Crear-Personaje {
    Write-Host "¿Cuál es tu nombre, aventurero?" -ForegroundColor Green
    $nombre = Read-Host "Nombre"
    
    $script:jugador.nombre = $nombre
    $script:jugador.vida = 100
    $script:jugador.mana = 50
    $script:jugador.oro = 100
    
    # Agregar items iniciales
    $script:jugador.inventario["Póciones de Vida"] = 3
    $script:jugador.inventario["Espada"] = 1
    
    Write-Host "`n¡Bienvenido, $nombre!" -ForegroundColor Green
    Write-Host "Vida: $($script:jugador.vida) | Maná: $($script:jugador.mana) | Oro: $($script:jugador.oro)" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Presiona Enter para continuar"
}

# Función para mostrar estadísticas
function Mostrar-Estadisticas {
    Write-Host "`n╔════════════════════════════════════════════╗" -ForegroundColor Yellow
    Write-Host "║          ESTADÍSTICAS DEL JUGADOR          ║" -ForegroundColor Yellow
    Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Nombre:      $($script:jugador.nombre)" -ForegroundColor White
    Write-Host "Nivel:       $($script:jugador.nivel)" -ForegroundColor White
    Write-Host "Experiencia: $($script:jugador.experiencia)" -ForegroundColor White
    Write-Host "Vida:        $($script:jugador.vida)/$($script:jugador.vidaMaxima)" -ForegroundColor White
    Write-Host "Maná:        $($script:jugador.mana)/50" -ForegroundColor White
    Write-Host "Fuerza:      $($script:jugador.fuerza)" -ForegroundColor White
    Write-Host "Defensa:     $($script:jugador.defensa)" -ForegroundColor White
    Write-Host "Oro:         $($script:jugador.oro)" -ForegroundColor Yellow
    Write-Host ""
}

# Función para mostrar inventario
function Mostrar-Inventario {
    Write-Host "`n╔════════════════════════════════════════════╗" -ForegroundColor Magenta
    Write-Host "║             TU INVENTARIO                  ║" -ForegroundColor Magenta
    Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Magenta
    Write-Host ""
    
    if ($script:jugador.inventario.Count -eq 0) {
        Write-Host "Tu inventario está vacío" -ForegroundColor Yellow
    } else {
        foreach ($item in $script:jugador.inventario.GetEnumerator()) {
            Write-Host "• $($item.Key): $($item.Value)" -ForegroundColor White
        }
    }
    Write-Host ""
}

# Función para combate
function Iniciar-Combate {
    $enemigos = @(
        @{ nombre = "Lobo"; vidaMax = 30; fuerza = 8; defensa = 2; xp = 50; oro = 25 },
        @{ nombre = "Goblin"; vidaMax = 25; fuerza = 6; defensa = 1; xp = 40; oro = 20 },
        @{ nombre = "Esqueleto"; vidaMax = 35; fuerza = 9; defensa = 3; xp = 60; oro = 30 },
        @{ nombre = "Dragón Pequeño"; vidaMax = 50; fuerza = 15; defensa = 5; xp = 100; oro = 75 }
    )
    
    $enemigo = $enemigos | Get-Random
    $enemigo.vida = $enemigo.vidaMax
    
    Write-Host "`n╔════════════════════════════════════════════╗" -ForegroundColor Red
    Write-Host "║          🗡️ COMBATE INICIADO! 🗡️          ║" -ForegroundColor Red
    Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Red
    Write-Host ""
    Write-Host "¡Un $($enemigo.nombre) te ataca!" -ForegroundColor Red
    Write-Host "Vida del enemigo: $($enemigo.vida)/$($enemigo.vidaMax)" -ForegroundColor Yellow
    Write-Host ""
    
    $combateActivo = $true
    
    while ($combateActivo) {
        Write-Host "Tu vida: $($script:jugador.vida)/$($script:jugador.vidaMaxima)" -ForegroundColor Cyan
        Write-Host "Vida del enemigo: $($enemigo.vida)/$($enemigo.vidaMax)" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "¿Qué haces?" -ForegroundColor Green
        Write-Host "1) Atacar" -ForegroundColor White
        Write-Host "2) Habilidad Especial (20 maná)" -ForegroundColor White
        Write-Host "3) Usar Pócima de Vida" -ForegroundColor White
        Write-Host "4) Huir" -ForegroundColor White
        Write-Host ""
        
        $opcion = Read-Host "Elige (1-4)"
        
        switch ($opcion) {
            "1" {
                # Ataque normal
                $daño = (Get-Random -Minimum 5 -Maximum 15) + $script:jugador.fuerza
                $enemigo.vida -= $daño
                Write-Host "¡Atacaste al $($enemigo.nombre) por $daño de daño!" -ForegroundColor Green
                Write-Host ""
            }
            "2" {
                # Habilidad especial
                if ($script:jugador.mana -ge 20) {
                    $daño = (Get-Random -Minimum 20 -Maximum 35) + $script:jugador.fuerza
                    $enemigo.vida -= $daño
                    $script:jugador.mana -= 20
                    Write-Host "⚡ ¡Usaste Habilidad Especial por $daño de daño!" -ForegroundColor Magenta
                    Write-Host "Maná restante: $($script:jugador.mana)/50" -ForegroundColor Cyan
                    Write-Host ""
                } else {
                    Write-Host "No tienes suficiente maná (necesitas 20, tienes $($script:jugador.mana))" -ForegroundColor Red
                    Write-Host ""
                    continue
                }
            }
            "3" {
                # Usar pócima
                if ($script:jugador.inventario["Póciones de Vida"] -gt 0) {
                    $script:jugador.vida += 30
                    if ($script:jugador.vida -gt $script:jugador.vidaMaxima) {
                        $script:jugador.vida = $script:jugador.vidaMaxima
                    }
                    $script:jugador.inventario["Póciones de Vida"]--
                    Write-Host "¡Usaste una pócima! Recuperaste 30 de vida." -ForegroundColor Green
                    Write-Host "Pócimas restantes: $($script:jugador.inventario["Póciones de Vida"])" -ForegroundColor Yellow
                    Write-Host ""
                } else {
                    Write-Host "No tienes pócimas disponibles" -ForegroundColor Red
                    Write-Host ""
                    continue
                }
            }
            "4" {
                # Huir
                $escapar = Get-Random -Minimum 1 -Maximum 100
                if ($escapar -gt 50) {
                    Write-Host "¡Escapaste del combate!" -ForegroundColor Yellow
                    Write-Host ""
                    return
                } else {
                    Write-Host "¡No pudiste escapar!" -ForegroundColor Red
                    Write-Host ""
                }
            }
            default {
                Write-Host "Opción inválida. Intenta de nuevo." -ForegroundColor Red
                Write-Host ""
                continue
            }
        }
        
        # Verificar si el enemigo fue derrotado
        if ($enemigo.vida -le 0) {
            Write-Host "`n╔════════════════════════════════════════════╗" -ForegroundColor Green
            Write-Host "║      ¡VICTORIA! 🎉 $($enemigo.nombre) derrotado    ║" -ForegroundColor Green
            Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Green
            Write-Host ""
            Write-Host "Ganaste $($enemigo.xp) de experiencia" -ForegroundColor Yellow
            Write-Host "Ganaste $($enemigo.oro) de oro" -ForegroundColor Yellow
            
            $script:jugador.experiencia += $enemigo.xp
            $script:jugador.oro += $enemigo.oro
            
            # Verificar si sube de nivel
            if ($script:jugador.experiencia -ge 100) {
                Subir-Nivel
            }
            
            $combateActivo = $false
            Write-Host ""
            Read-Host "Presiona Enter para continuar"
            return
        }
        
        # Turno del enemigo
        Write-Host "`n$($enemigo.nombre) contraataca..." -ForegroundColor Red
        $dañoEnemigo = (Get-Random -Minimum 3 -Maximum 12) + $enemigo.fuerza
        $script:jugador.vida -= $dañoEnemigo
        Write-Host "$($enemigo.nombre) te hizo $dañoEnemigo de daño" -ForegroundColor Red
        Write-Host ""
        
        # Verificar si el jugador fue derrotado
        if ($script:jugador.vida -le 0) {
            Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor DarkRed
            Write-Host "║      ¡DERROTA! 💀 Fuiste derrotado       ║" -ForegroundColor DarkRed
            Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor DarkRed
            Write-Host ""
            Write-Host "Perdiste 50 de oro" -ForegroundColor Yellow
            $script:jugador.oro = [Math]::Max(0, $script:jugador.oro - 50)
            $script:jugador.vida = $script:jugador.vidaMaxima
            Write-Host ""
            Read-Host "Presiona Enter para continuar"
            return
        }
        
        Read-Host "Presiona Enter para continuar"
        Clear-Host
    }
}

# Función para subir de nivel
function Subir-Nivel {
    $script:jugador.nivel++
    $script:jugador.experiencia = 0
    $script:jugador.vidaMaxima += 20
    $script:jugador.vida = $script:jugador.vidaMaxima
    $script:jugador.mana += 10
    $script:jugador.fuerza += 3
    $script:jugador.defensa += 2
    
    Write-Host "`n╔════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║        🎉 ¡SUBIDA DE NIVEL! 🎉          ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Nuevo Nivel: $($script:jugador.nivel)" -ForegroundColor Yellow
    Write-Host "Vida Máxima: $($script:jugador.vidaMaxima)" -ForegroundColor Yellow
    Write-Host "Fuerza: $($script:jugador.fuerza)" -ForegroundColor Yellow
    Write-Host "Defensa: $($script:jugador.defensa)" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Presiona Enter para continuar"
}

# Función para explorar
function Explorar {
    Write-Host "`n¿A dónde quieres ir?" -ForegroundColor Green
    Write-Host "1) Bosque Oscuro" -ForegroundColor White
    Write-Host "2) Ruinas Antiguas" -ForegroundColor White
    Write-Host "3) Montaña Nevada" -ForegroundColor White
    Write-Host ""
    
    $ubicacion = Read-Host "Elige una ubicación (1-3)"
    
    $descripciones = @{
        "1" = "El Bosque Oscuro es peligroso y lleno de criaturas salvajes"
        "2" = "Las Ruinas Antiguas guardan secretos de civilizaciones perdidas"
        "3" = "La Montaña Nevada es extremadamente peligrosa"
    }
    
    if ($descripciones.ContainsKey($ubicacion)) {
        Write-Host "`nHas llegado a: " -ForegroundColor Cyan
        Write-Host $descripciones[$ubicacion] -ForegroundColor White
        Write-Host ""
        Write-Host "Presiona Enter para explorar..." -ForegroundColor Yellow
        Read-Host ""
        Iniciar-Combate
    } else {
        Write-Host "Ubicación no válida" -ForegroundColor Red
    }
}

# Función para tienda
function Ir-Tienda {
    Write-Host "`n╔════════════════════════════════════════════╗" -ForegroundColor Magenta
    Write-Host "║             TIENDA DEL PUEBLO             ║" -ForegroundColor Magenta
    Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "Oro disponible: $($script:jugador.oro)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "¿Qué quieres comprar?" -ForegroundColor Green
    Write-Host "1) Pócima de Vida (20 oro)" -ForegroundColor White
    Write-Host "2) Pócima de Maná (15 oro)" -ForegroundColor White
    Write-Host "3) Salir de la tienda" -ForegroundColor White
    Write-Host ""
    
    $opcion = Read-Host "Elige (1-3)"
    
    switch ($opcion) {
        "1" {
            if ($script:jugador.oro -ge 20) {
                $script:jugador.oro -= 20
                if (-not $script:jugador.inventario.ContainsKey("Póciones de Vida")) {
                    $script:jugador.inventario["Póciones de Vida"] = 0
                }
                $script:jugador.inventario["Póciones de Vida"]++
                Write-Host "¡Compraste una Pócima de Vida!" -ForegroundColor Green
            } else {
                Write-Host "No tienes suficiente oro" -ForegroundColor Red
            }
        }
        "2" {
            if ($script:jugador.oro -ge 15) {
                $script:jugador.oro -= 15
                if (-not $script:jugador.inventario.ContainsKey("Pócimas de Maná")) {
                    $script:jugador.inventario["Pócimas de Maná"] = 0
                }
                $script:jugador.inventario["Pócimas de Maná"]++
                Write-Host "¡Compraste una Pócima de Maná!" -ForegroundColor Green
            } else {
                Write-Host "No tienes suficiente oro" -ForegroundColor Red
            }
        }
        "3" {
            Write-Host "Saliste de la tienda" -ForegroundColor Yellow
        }
    }
    Write-Host ""
}

# Función del menú principal del juego
function Menu-Juego {
    $juegoActivo = $true
    
    while ($juegoActivo) {
        Clear-Host
        Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Cyan
        Write-Host "║       $($script:jugador.nombre) - Nivel $($script:jugador.nivel)              ║" -ForegroundColor Cyan
        Write-Host "║   Vida: $($script:jugador.vida)/$($script:jugador.vidaMaxima) | Oro: $($script:jugador.oro) | XP: $($script:jugador.experiencia)       ║" -ForegroundColor Cyan
        Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "¿Qué quieres hacer?" -ForegroundColor Green
        Write-Host "1) Explorar" -ForegroundColor White
        Write-Host "2) Ver Estadísticas" -ForegroundColor White
        Write-Host "3) Ver Inventario" -ForegroundColor White
        Write-Host "4) Ir a la Tienda" -ForegroundColor White
        Write-Host "5) Descansar (Recuperar Vida y Maná)" -ForegroundColor White
        Write-Host "6) Salir del Juego" -ForegroundColor White
        Write-Host ""
        
        $opcion = Read-Host "Elige una opción (1-6)"
        
        switch ($opcion) {
            "1" { Explorar }
            "2" { Mostrar-Estadisticas; Read-Host "Presiona Enter para continuar" }
            "3" { Mostrar-Inventario; Read-Host "Presiona Enter para continuar" }
            "4" { Ir-Tienda; Read-Host "Presiona Enter para continuar" }
            "5" {
                $script:jugador.vida = $script:jugador.vidaMaxima
                $script:jugador.mana = 50
                Write-Host "`nDescansaste y recuperaste toda tu vida y maná" -ForegroundColor Green
                Read-Host "Presiona Enter para continuar"
            }
            "6" {
                $juegoActivo = $false
                Write-Host "`n¡Gracias por jugar!" -ForegroundColor Yellow
                Mostrar-Estadisticas
            }
            default {
                Write-Host "Opción inválida" -ForegroundColor Red
            }
        }
    }
}

# Iniciar el juego
Mostrar-MenuPrincipal
Crear-Personaje
Menu-Juego
