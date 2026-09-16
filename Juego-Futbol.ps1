# ============================================
# PowerShell Football Game - Para 2 Jugadores
# ============================================

# Función de dormir (animada)
function Show-Sleeping {
    param(
        [int]$Duration = 5
    )
    
    $inicio = Get-Date
    
    while ((Get-Date) - $inicio -lt [timespan]::FromSeconds($Duration)) {
        Clear-Host
        Write-Host "  zzZZzzZZzzZZ" -ForegroundColor Yellow
        Write-Host "    ╔═════════╗" -ForegroundColor Cyan
        Write-Host "    ║  👤 😴  ║" -ForegroundColor Cyan
        Write-Host "    ║  ═════  ║" -ForegroundColor Cyan
        Write-Host "    ╚═════════╝" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "      💤 💤 💤" -ForegroundColor Blue
        
        Start-Sleep -Milliseconds 500
        
        Clear-Host
        Write-Host "  zZzZzZzZzZ" -ForegroundColor Yellow
        Write-Host "    ╔═════════╗" -ForegroundColor Cyan
        Write-Host "    ║  👤 😴  ║" -ForegroundColor Cyan
        Write-Host "    ║  ─────  ║" -ForegroundColor Cyan
        Write-Host "    ╚═════════╝" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "      💤   💤" -ForegroundColor Blue
        
        Start-Sleep -Milliseconds 500
    }
}

# Variables del juego
$juego = @{
    jugador1 = @{nombre = ""; goles = 0; posicion = 45; energia = 100}
    jugador2 = @{nombre = ""; goles = 0; posicion = 45; energia = 100}
    balon = @{posicion = 50; poseedor = 0}
    tiempo = 0
    tiempoTotal = 5  # 5 minutos para demo
    turno = 1
}

# Mostrar portería
function Show-Campo {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                          ⚽ CAMPO DE FÚTBOL ⚽                                        ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    
    $campo = ""
    for ($i = 0; $i -lt 90; $i++) {
        if ($i -eq 44 -or $i -eq 45) {
            $campo += "║"
        } elseif ($i -eq $juego.balon.posicion) {
            $campo += "⚽"
        } elseif ($i -eq $juego.jugador1.posicion) {
            $campo += "🔴"
        } elseif ($i -eq $juego.jugador2.posicion) {
            $campo += "🔵"
        } else {
            $campo += "─"
        }
    }
    
    Write-Host "🥅 " + $campo + " 🥅" -ForegroundColor White
    Write-Host ""
}

# Mostrar marcador
function Show-Marcador {
    Write-Host "╔════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Yellow
    Write-Host "║" -ForegroundColor Yellow -NoNewline
    Write-Host " 🔴 $($juego.jugador1.nombre): $($juego.jugador1.goles) GOLES " -ForegroundColor Red -NoNewline
    Write-Host " | " -ForegroundColor Yellow -NoNewline
    Write-Host " TIEMPO: $($juego.tiempo)/$($juego.tiempoTotal) MIN " -ForegroundColor Yellow -NoNewline
    Write-Host " | " -ForegroundColor Yellow -NoNewline
    Write-Host " 🔵 $($juego.jugador2.nombre): $($juego.jugador2.goles) GOLES " -ForegroundColor Blue -NoNewline
    Write-Host " ║" -ForegroundColor Yellow
    Write-Host "╚════════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
}

# Mostrar energía
function Show-Energia {
    Write-Host ""
    Write-Host "Energía de $($juego.jugador1.nombre) 🔴: " -NoNewline -ForegroundColor Red
    $barraEnergia1 = ""
    for ($i = 0; $i -lt 20; $i++) {
        if ($i -lt [int]($juego.jugador1.energia / 5)) {
            $barraEnergia1 += "█"
        } else {
            $barraEnergia1 += "░"
        }
    }
    Write-Host $barraEnergia1 " $($juego.jugador1.energia)%" -ForegroundColor Green
    
    Write-Host "Energía de $($juego.jugador2.nombre) 🔵: " -NoNewline -ForegroundColor Blue
    $barraEnergia2 = ""
    for ($i = 0; $i -lt 20; $i++) {
        if ($i -lt [int]($juego.jugador2.energia / 5)) {
            $barraEnergia2 += "█"
        } else {
            $barraEnergia2 += "░"
        }
    }
    Write-Host $barraEnergia2 " $($juego.jugador2.energia)%" -ForegroundColor Green
    Write-Host ""
}

# Menú principal del fútbol
function Menu-Futbol {
    Clear-Host
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                                                                                        ║" -ForegroundColor Cyan
    Write-Host "║                        ⚽ BIENVENIDO AL JUEGO DE FÚTBOL ⚽                            ║" -ForegroundColor Cyan
    Write-Host "║                                                                                        ║" -ForegroundColor Cyan
    Write-Host "║                           JUEGO PARA DOS JUGADORES                                    ║" -ForegroundColor Cyan
    Write-Host "║                                                                                        ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "Ingresa el nombre del Jugador 1 🔴" -ForegroundColor Red
    $j1 = Read-Host "Nombre"
    $script:juego.jugador1.nombre = $j1
    
    Write-Host ""
    Write-Host "Ingresa el nombre del Jugador 2 🔵" -ForegroundColor Blue
    $j2 = Read-Host "Nombre"
    $script:juego.jugador2.nombre = $j2
    
    Iniciar-Partido
}

# Iniciar partido
function Iniciar-Partido {
    $juegoActivo = $true
    
    Write-Host "`n¡El partido está comenzando!" -ForegroundColor Green
    Start-Sleep -Seconds 2
    
    while ($juegoActivo -and $script:juego.tiempo -lt $script:juego.tiempoTotal) {
        Clear-Host
        
        Show-Marcador
        Show-Campo
        Show-Energia
        
        if ($script:juego.balon.poseedor -eq 1) {
            Write-Host "🔴 TURNO DE $($script:juego.jugador1.nombre)" -ForegroundColor Red
            Write-Host ""
            Write-Host "¿Qué quieres hacer?" -ForegroundColor Green
            Write-Host "1) Pasar el balón" -ForegroundColor White
            Write-Host "2) Ir hacia el gol" -ForegroundColor White
            Write-Host "3) Disparar" -ForegroundColor White
            Write-Host "4) Defensiva (esperar)" -ForegroundColor White
            
            $opcion = Read-Host "Elige (1-4)"
            
            Procesar-Movimiento -Jugador 1 -Opcion $opcion
        } else {
            Write-Host "🔵 TURNO DE $($script:juego.jugador2.nombre)" -ForegroundColor Blue
            Write-Host ""
            Write-Host "¿Qué quieres hacer?" -ForegroundColor Green
            Write-Host "1) Pasar el balón" -ForegroundColor White
            Write-Host "2) Ir hacia el gol" -ForegroundColor White
            Write-Host "3) Disparar" -ForegroundColor White
            Write-Host "4) Defensiva (esperar)" -ForegroundColor White
            
            $opcion = Read-Host "Elige (1-4)"
            
            Procesar-Movimiento -Jugador 2 -Opcion $opcion
        }
        
        $script:juego.tiempo++
    }
    
    Mostrar-Resultado-Final
}

# Procesar movimiento
function Procesar-Movimiento {
    param(
        [int]$Jugador,
        [string]$Opcion
    )
    
    $enemigo = if ($Jugador -eq 1) { 2 } else { 1 }
    $jug = if ($Jugador -eq 1) { $script:juego.jugador1 } else { $script:juego.jugador2 }
    $enm = if ($Jugador -eq 1) { $script:juego.jugador2 } else { $script:juego.jugador1 }
    
    switch ($Opcion) {
        "1" {
            # Pasar el balón
            $exito = Get-Random -Minimum 1 -Maximum 100
            if ($exito -gt 30) {
                Write-Host "`n✅ ¡Pase exitoso!" -ForegroundColor Green
                $script:juego.balon.poseedor = $enemigo
                $jug.energia -= 5
            } else {
                Write-Host "`n❌ ¡El pase fue interceptado!" -ForegroundColor Red
                $script:juego.balon.poseedor = $enemigo
                $jug.energia -= 3
            }
        }
        "2" {
            # Ir hacia el gol
            if ($Jugador -eq 1) {
                if ($jug.posicion -lt 80) {
                    $jug.posicion += (Get-Random 5 15)
                    if ($jug.posicion -gt 80) { $jug.posicion = 80 }
                    Write-Host "`n⬆️ ¡Avanzaste hacia el gol!" -ForegroundColor Cyan
                    $script:juego.balon.posicion = $jug.posicion
                    $jug.energia -= 8
                } else {
                    Write-Host "`n⚠️ ¡Ya estás en posición de tiro!" -ForegroundColor Yellow
                }
            } else {
                if ($jug.posicion -gt 10) {
                    $jug.posicion -= (Get-Random 5 15)
                    if ($jug.posicion -lt 10) { $jug.posicion = 10 }
                    Write-Host "`n⬇️ ¡Avanzaste hacia el gol!" -ForegroundColor Cyan
                    $script:juego.balon.posicion = $jug.posicion
                    $jug.energia -= 8
                } else {
                    Write-Host "`n⚠️ ¡Ya estás en posición de tiro!" -ForegroundColor Yellow
                }
            }
        }
        "3" {
            # Disparar
            if (($Jugador -eq 1 -and $jug.posicion -gt 70) -or ($Jugador -eq 2 -and $jug.posicion -lt 20)) {
                $fuerza = Get-Random 30 100
                $defensa = Get-Random 20 80
                
                if ($fuerza -gt $defensa) {
                    Write-Host "`n⚽ ¡¡¡GOOOOOOL!!! 🎉" -ForegroundColor Green
                    Write-Host "¡$($jug.nombre) anotó!" -ForegroundColor Green
                    $jug.goles++
                    $script:juego.balon.poseedor = $enemigo
                    $script:juego.balon.posicion = 50
                    $jug.posicion = 50
                } else {
                    Write-Host "`n❌ ¡Disparo bloqueado o fuera!" -ForegroundColor Red
                    $script:juego.balon.poseedor = $enemigo
                    $jug.energia -= 10
                }
            } else {
                Write-Host "`n❌ ¡Estás muy lejos para disparar!" -ForegroundColor Red
            }
        }
        "4" {
            # Defensiva
            Write-Host "`n🛡️ Posición defensiva tomada" -ForegroundColor Cyan
            $jug.energia += 5
            if ($jug.energia -gt 100) { $jug.energia = 100 }
        }
        default {
            Write-Host "`n⚠️ Opción inválida" -ForegroundColor Yellow
        }
    }
    
    # Regenerar un poco de energía
    if ($jug.energia -lt 100) {
        $jug.energia += 2
        if ($jug.energia -gt 100) { $jug.energia = 100 }
    }
    
    Read-Host "`nPresiona Enter para continuar"
}

# Mostrar resultado final
function Mostrar-Resultado-Final {
    Clear-Host
    
    Write-Host "`n╔════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                              🏆 FIN DEL PARTIDO 🏆                                    ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    
    Write-Host ""
    Write-Host "RESULTADO FINAL:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "🔴 $($script:juego.jugador1.nombre): " -ForegroundColor Red -NoNewline
    Write-Host "$($script:juego.jugador1.goles) GOLES" -ForegroundColor Green
    Write-Host ""
    Write-Host "🔵 $($script:juego.jugador2.nombre): " -ForegroundColor Blue -NoNewline
    Write-Host "$($script:juego.jugador2.goles) GOLES" -ForegroundColor Green
    Write-Host ""
    
    if ($script:juego.jugador1.goles -gt $script:juego.jugador2.goles) {
        Write-Host "╔════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
        Write-Host "║" -ForegroundColor Green -NoNewline
        Write-Host "                    🎉 ¡$($script:juego.jugador1.nombre) es el campeón! 🎉                    " -ForegroundColor Green -NoNewline
        Write-Host "║" -ForegroundColor Green
        Write-Host "╚════════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    } elseif ($script:juego.jugador2.goles -gt $script:juego.jugador1.goles) {
        Write-Host "╔════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
        Write-Host "║" -ForegroundColor Green -NoNewline
        Write-Host "                    🎉 ¡$($script:juego.jugador2.nombre) es el campeón! 🎉                    " -ForegroundColor Green -NoNewline
        Write-Host "║" -ForegroundColor Green
        Write-Host "╚════════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    } else {
        Write-Host "╔════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Yellow
        Write-Host "║" -ForegroundColor Yellow -NoNewline
        Write-Host "                         ⚽ ¡Es un empate! ⚽                              " -ForegroundColor Yellow -NoNewline
        Write-Host "║" -ForegroundColor Yellow
        Write-Host "╚════════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "¿Quieres jugar de nuevo?" -ForegroundColor Green
    Write-Host "1) Sí" -ForegroundColor White
    Write-Host "2) No" -ForegroundColor White
    
    $opcion = Read-Host "Elige (1-2)"
    
    if ($opcion -eq "1") {
        # Reiniciar variables
        $script:juego.jugador1.goles = 0
        $script:juego.jugador2.goles = 0
        $script:juego.jugador1.posicion = 45
        $script:juego.jugador2.posicion = 45
        $script:juego.jugador1.energia = 100
        $script:juego.jugador2.energia = 100
        $script:juego.balon.posicion = 50
        $script:juego.balon.poseedor = 1
        $script:juego.tiempo = 0
        
        Iniciar-Partido
    } else {
        Write-Host "`n¡Gracias por jugar fútbol!" -ForegroundColor Yellow
        Write-Host "Hasta pronto 👋" -ForegroundColor Cyan
    }
}

# Iniciar el juego
Menu-Futbol
