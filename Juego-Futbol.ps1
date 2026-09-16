# ============================================
# PowerShell Football Game EXPANDIDO - Para 2 Jugadores
# ============================================

# Variables del juego
$futbol = @{
    jugador1 = @{nombre = ""; goles = 0; posicion = 45; energia = 100; tarjetas_amarillas = 0; tarjetas_rojas = 0}
    jugador2 = @{nombre = ""; goles = 0; posicion = 45; energia = 100; tarjetas_amarillas = 0; tarjetas_rojas = 0}
    balon = @{posicion = 50; poseedor = 0; velocidad = 0}
    tiempo = 0
    tiempoTotal = 45  # 45 minutos por tiempo
    turno = 1
    parte = 1
    estado = "Jugando"
    estadisticas = @{
        pases_j1 = 0
        pases_j2 = 0
        tiros_j1 = 0
        tiros_j2 = 0
        atajadas_j1 = 0
        atajadas_j2 = 0
    }
}

# Función para mostrar el campo
function Show-Campo {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                          ⚽ CAMPO DE FÚTBOL ⚽                                        ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    
    $campo = ""
    for ($i = 0; $i -lt 90; $i++) {
        if ($i -eq 44 -or $i -eq 45) {
            $campo += "║"
        } elseif ($i -eq $script:futbol.balon.posicion) {
            $campo += "⚽"
        } elseif ($i -eq $script:futbol.jugador1.posicion) {
            $campo += "🔴"
        } elseif ($i -eq $script:futbol.jugador2.posicion) {
            $campo += "🔵"
        } else {
            $campo += "─"
        }
    }
    
    Write-Host "🥅 " + $campo + " 🥅" -ForegroundColor White
    Write-Host ""
}

# Función para mostrar marcador
function Show-Marcador {
    Write-Host "╔════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Yellow
    Write-Host "║" -ForegroundColor Yellow -NoNewline
    Write-Host " 🔴 $($script:futbol.jugador1.nombre): $($script:futbol.jugador1.goles) GOLES " -ForegroundColor Red -NoNewline
    Write-Host " | " -ForegroundColor Yellow -NoNewline
    Write-Host " TIEMPO: $($script:futbol.tiempo)/$($script:futbol.tiempoTotal) MIN (Parte $($script:futbol.parte)) " -ForegroundColor Yellow -NoNewline
    Write-Host " | " -ForegroundColor Yellow -NoNewline
    Write-Host " 🔵 $($script:futbol.jugador2.nombre): $($script:futbol.jugador2.goles) GOLES " -ForegroundColor Blue -NoNewline
    Write-Host " ║" -ForegroundColor Yellow
    Write-Host "╚════════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
}

# Función para mostrar energía
function Show-Energia {
    Write-Host ""
    Write-Host "Energía de $($script:futbol.jugador1.nombre) 🔴: " -NoNewline -ForegroundColor Red
    $barraEnergia1 = ""
    for ($i = 0; $i -lt 20; $i++) {
        if ($i -lt [int]($script:futbol.jugador1.energia / 5)) {
            $barraEnergia1 += "█"
        } else {
            $barraEnergia1 += "░"
        }
    }
    Write-Host $barraEnergia1 " $($script:futbol.jugador1.energia)%" -ForegroundColor Green
    
    Write-Host "Energía de $($script:futbol.jugador2.nombre) 🔵: " -NoNewline -ForegroundColor Blue
    $barraEnergia2 = ""
    for ($i = 0; $i -lt 20; $i++) {
        if ($i -lt [int]($script:futbol.jugador2.energia / 5)) {
            $barraEnergia2 += "█"
        } else {
            $barraEnergia2 += "░"
        }
    }
    Write-Host $barraEnergia2 " $($script:futbol.jugador2.energia)%" -ForegroundColor Green
    Write-Host ""
}

# Función para mostrar estadísticas
function Show-Estadisticas-Partido {
    Write-Host ""
    Write-Host "📊 ESTADÍSTICAS DEL PARTIDO:" -ForegroundColor Cyan
    Write-Host "  Pases 🔴: $($script:futbol.estadisticas.pases_j1) | Pases 🔵: $($script:futbol.estadisticas.pases_j2)" -ForegroundColor White
    Write-Host "  Tiros 🔴: $($script:futbol.estadisticas.tiros_j1) | Tiros 🔵: $($script:futbol.estadisticas.tiros_j2)" -ForegroundColor White
    Write-Host "  Atajadas 🔴: $($script:futbol.estadisticas.atajadas_j1) | Atajadas 🔵: $($script:futbol.estadisticas.atajadas_j2)" -ForegroundColor White
    Write-Host ""
}

# Función para mostrar tarjetas
function Show-Tarjetas {
    if ($script:futbol.jugador1.tarjetas_amarillas -gt 0 -or $script:futbol.jugador1.tarjetas_rojas -gt 0) {
        Write-Host "🔴 $($script:futbol.jugador1.nombre) - Amarillas: $($script:futbol.jugador1.tarjetas_amarillas) 🟨 | Rojas: $($script:futbol.jugador1.tarjetas_rojas) 🟥" -ForegroundColor Red
    }
    if ($script:futbol.jugador2.tarjetas_amarillas -gt 0 -or $script:futbol.jugador2.tarjetas_rojas -gt 0) {
        Write-Host "🔵 $($script:futbol.jugador2.nombre) - Amarillas: $($script:futbol.jugador2.tarjetas_amarillas) 🟨 | Rojas: $($script:futbol.jugador2.tarjetas_rojas) 🟥" -ForegroundColor Blue
    }
}

# Función para menú principal
function Show-MenuFutbol {
    Clear-Host
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                                                                                        ║" -ForegroundColor Cyan
    Write-Host "║                        ⚽ BIENVENIDO AL FÚTBOL EXPANDIDO ⚽                           ║" -ForegroundColor Cyan
    Write-Host "║                                                                                        ║" -ForegroundColor Cyan
    Write-Host "║                           JUEGO PARA DOS JUGADORES                                    ║" -ForegroundColor Cyan
    Write-Host "║                                                                                        ║" -ForegroundColor Cyan
    Write-Host "║                     2 TIEMPOS DE 45 MINUTOS CADA UNO                                  ║" -ForegroundColor Cyan
    Write-Host "║                                                                                        ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "Ingresa el nombre del Jugador 1 🔴" -ForegroundColor Red
    $j1 = Read-Host "Nombre"
    $script:futbol.jugador1.nombre = $j1
    
    Write-Host ""
    Write-Host "Ingresa el nombre del Jugador 2 🔵" -ForegroundColor Blue
    $j2 = Read-Host "Nombre"
    $script:futbol.jugador2.nombre = $j2
    
    Iniciar-Partido
}

# Función para iniciar el partido
function Iniciar-Partido {
    Write-Host "`n¡El partido va a comenzar!" -ForegroundColor Green
    Write-Host "🔴 $($script:futbol.jugador1.nombre) vs 🔵 $($script:futbol.jugador2.nombre)" -ForegroundColor Yellow
    Start-Sleep -Seconds 3
    
    $script:futbol.parte = 1
    Jugar-Tiempo
    
    # Descanso de medio tiempo
    Clear-Host
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                         ⏱️ DESCANSO DE MEDIO TIEMPO ⏱️                               ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "🔴 $($script:futbol.jugador1.nombre): $($script:futbol.jugador1.goles) goles" -ForegroundColor Red
    Write-Host "🔵 $($script:futbol.jugador2.nombre): $($script:futbol.jugador2.goles) goles" -ForegroundColor Blue
    Write-Host ""
    Write-Host "Los jugadores descansan y recuperan energía..." -ForegroundColor Yellow
    
    # Restaurar energía
    $script:futbol.jugador1.energia = 100
    $script:futbol.jugador2.energia = 100
    $script:futbol.tiempo = 0
    $script:futbol.balon.posicion = 50
    $script:futbol.balon.poseedor = 2  # Segundo tiempo comienza el otro equipo
    
    Start-Sleep -Seconds 3
    
    $script:futbol.parte = 2
    Jugar-Tiempo
    
    Mostrar-Resultado-Final
}

# Función para jugar un tiempo
function Jugar-Tiempo {
    $juegoActivo = $true
    
    while ($juegoActivo -and $script:futbol.tiempo -lt $script:futbol.tiempoTotal) {
        Clear-Host
        
        Show-Marcador
        Show-Campo
        Show-Energia
        Show-Estadisticas-Partido
        Show-Tarjetas
        
        if ($script:futbol.balon.poseedor -eq 1) {
            Write-Host "🔴 TURNO DE $($script:futbol.jugador1.nombre)" -ForegroundColor Red
            Write-Host ""
            Write-Host "¿Qué quieres hacer?" -ForegroundColor Green
            Write-Host "1) Pasar el balón" -ForegroundColor White
            Write-Host "2) Regate (Avanzar con el balón)" -ForegroundColor White
            Write-Host "3) Disparo a puerta" -ForegroundColor White
            Write-Host "4) Defensa (esperar)" -ForegroundColor White
            Write-Host "5) Falta intencional" -ForegroundColor White
            
            $opcion = Read-Host "Elige (1-5)"
            
            Procesar-Movimiento -Jugador 1 -Opcion $opcion
        } else {
            Write-Host "🔵 TURNO DE $($script:futbol.jugador2.nombre)" -ForegroundColor Blue
            Write-Host ""
            Write-Host "¿Qué quieres hacer?" -ForegroundColor Green
            Write-Host "1) Pasar el balón" -ForegroundColor White
            Write-Host "2) Regate (Avanzar con el balón)" -ForegroundColor White
            Write-Host "3) Disparo a puerta" -ForegroundColor White
            Write-Host "4) Defensa (esperar)" -ForegroundColor White
            Write-Host "5) Falta intencional" -ForegroundColor White
            
            $opcion = Read-Host "Elige (1-5)"
            
            Procesar-Movimiento -Jugador 2 -Opcion $opcion
        }
        
        $script:futbol.tiempo++
    }
}

# Función para procesar movimientos
function Procesar-Movimiento {
    param(
        [int]$Jugador,
        [string]$Opcion
    )
    
    $enemigo = if ($Jugador -eq 1) { 2 } else { 1 }
    $jug = if ($Jugador -eq 1) { $script:futbol.jugador1 } else { $script:futbol.jugador2 }
    $enm = if ($Jugador -eq 1) { $script:futbol.jugador2 } else { $script:futbol.jugador1 }
    
    switch ($Opcion) {
        "1" {
            # Pasar el balón
            $exito = Get-Random -Minimum 1 -Maximum 100
            if ($exito -gt 25) {
                Write-Host "`n✅ ¡Pase exitoso!" -ForegroundColor Green
                if ($Jugador -eq 1) { $script:futbol.estadisticas.pases_j1++ } else { $script:futbol.estadisticas.pases_j2++ }
                $script:futbol.balon.poseedor = $enemigo
                $jug.energia -= 3
            } else {
                Write-Host "`n❌ ¡El pase fue interceptado!" -ForegroundColor Red
                $script:futbol.balon.poseedor = $enemigo
                $jug.energia -= 2
                if ($Jugador -eq 2) { $script:futbol.estadisticas.atajadas_j1++ } else { $script:futbol.estadisticas.atajadas_j2++ }
            }
        }
        "2" {
            # Regate/Avanzar
            if ($Jugador -eq 1) {
                if ($jug.posicion -lt 80) {
                    $jug.posicion += (Get-Random 3 12)
                    if ($jug.posicion -gt 80) { $jug.posicion = 80 }
                    Write-Host "`n⚽ ¡Avanzaste hacia el gol!" -ForegroundColor Cyan
                    $script:futbol.balon.posicion = $jug.posicion
                    $jug.energia -= 12
                } else {
                    Write-Host "`n⚠️ ¡Ya estás en posición de tiro!" -ForegroundColor Yellow
                }
            } else {
                if ($jug.posicion -gt 10) {
                    $jug.posicion -= (Get-Random 3 12)
                    if ($jug.posicion -lt 10) { $jug.posicion = 10 }
                    Write-Host "`n⚽ ¡Avanzaste hacia el gol!" -ForegroundColor Cyan
                    $script:futbol.balon.posicion = $jug.posicion
                    $jug.energia -= 12
                } else {
                    Write-Host "`n⚠️ ¡Ya estás en posición de tiro!" -ForegroundColor Yellow
                }
            }
        }
        "3" {
            # Disparar
            if (($Jugador -eq 1 -and $jug.posicion -gt 70) -or ($Jugador -eq 2 -and $jug.posicion -lt 20)) {
                $fuerza = Get-Random 40 100
                $defensa = Get-Random 20 80
                if ($Jugador -eq 1) { $script:futbol.estadisticas.tiros_j1++ } else { $script:futbol.estadisticas.tiros_j2++ }
                
                if ($fuerza -gt $defensa) {
                    Write-Host "`n⚽ ¡¡¡GOOOOOOL!!! 🎉🎉🎉" -ForegroundColor Green
                    Write-Host "¡$($jug.nombre) anotó!" -ForegroundColor Green
                    $jug.goles++
                    $script:futbol.balon.poseedor = $enemigo
                    $script:futbol.balon.posicion = 50
                    $jug.posicion = 50
                } else {
                    Write-Host "`n❌ ¡Disparo bloqueado o fuera!" -ForegroundColor Red
                    $script:futbol.balon.poseedor = $enemigo
                    $jug.energia -= 15
                    if ($Jugador -eq 2) { $script:futbol.estadisticas.atajadas_j1++ } else { $script:futbol.estadisticas.atajadas_j2++ }
                }
            } else {
                Write-Host "`n❌ ¡Estás muy lejos para disparar!" -ForegroundColor Red
            }
        }
        "4" {
            # Defensiva
            Write-Host "`n🛡️ Posición defensiva tomada" -ForegroundColor Cyan
            $jug.energia += 8
            if ($jug.energia -gt 100) { $jug.energia = 100 }
        }
        "5" {
            # Falta intencional
            Write-Host "`n⚠️ ¡Falta intencional!" -ForegroundColor Yellow
            $jug.tarjetas_amarillas++
            
            if ($jug.tarjetas_amarillas -ge 2) {
                Write-Host "🔴 ¡TARJETA ROJA! ¡Fuiste expulsado!" -ForegroundColor Red
                $jug.tarjetas_rojas++
                Write-Host "El partido continúa sin ti..." -ForegroundColor Red
                $script:futbol.balon.poseedor = $enemigo
            } else {
                Write-Host "🟨 Tarjeta amarilla. Ten cuidado..." -ForegroundColor Yellow
                $script:futbol.balon.poseedor = $enemigo
            }
            
            $jug.energia -= 5
        }
        default {
            Write-Host "`n⚠️ Opción inválida" -ForegroundColor Yellow
        }
    }
    
    # Regenerar energía lentamente
    if ($jug.energia -lt 100) {
        $jug.energia += 1
        if ($jug.energia -gt 100) { $jug.energia = 100 }
    }
    
    Read-Host "`nPresiona Enter para continuar"
}

# Función para mostrar resultado final
function Mostrar-Resultado-Final {
    Clear-Host
    
    Write-Host "`n╔════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                              🏆 FIN DEL PARTIDO 🏆                                    ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    
    Write-Host ""
    Write-Host "RESULTADO FINAL:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "🔴 $($script:futbol.jugador1.nombre): " -ForegroundColor Red -NoNewline
    Write-Host "$($script:futbol.jugador1.goles) GOLES" -ForegroundColor Green
    Write-Host ""
    Write-Host "🔵 $($script:futbol.jugador2.nombre): " -ForegroundColor Blue -NoNewline
    Write-Host "$($script:futbol.jugador2.goles) GOLES" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "📊 ESTADÍSTICAS FINALES:" -ForegroundColor Cyan
    Write-Host "  Pases 🔴: $($script:futbol.estadisticas.pases_j1) | Pases 🔵: $($script:futbol.estadisticas.pases_j2)" -ForegroundColor White
    Write-Host "  Tiros 🔴: $($script:futbol.estadisticas.tiros_j1) | Tiros 🔵: $($script:futbol.estadisticas.tiros_j2)" -ForegroundColor White
    Write-Host "  Atajadas 🔴: $($script:futbol.estadisticas.atajadas_j1) | Atajadas 🔵: $($script:futbol.estadisticas.atajadas_j2)" -ForegroundColor White
    Write-Host ""
    
    if ($script:futbol.jugador1.goles -gt $script:futbol.jugador2.goles) {
        Write-Host "╔════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
        Write-Host "║" -ForegroundColor Green -NoNewline
        Write-Host "                    🎉 ¡$($script:futbol.jugador1.nombre) es el campeón! 🎉                    " -ForegroundColor Green -NoNewline
        Write-Host "║" -ForegroundColor Green
        Write-Host "╚════════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    } elseif ($script:futbol.jugador2.goles -gt $script:futbol.jugador1.goles) {
        Write-Host "╔════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
        Write-Host "║" -ForegroundColor Green -NoNewline
        Write-Host "                    🎉 ¡$($script:futbol.jugador2.nombre) es el campeón! 🎉                    " -ForegroundColor Green -NoNewline
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
        $script:futbol.jugador1.goles = 0
        $script:futbol.jugador2.goles = 0
        $script:futbol.jugador1.posicion = 45
        $script:futbol.jugador2.posicion = 45
        $script:futbol.jugador1.energia = 100
        $script:futbol.jugador2.energia = 100
        $script:futbol.jugador1.tarjetas_amarillas = 0
        $script:futbol.jugador1.tarjetas_rojas = 0
        $script:futbol.jugador2.tarjetas_amarillas = 0
        $script:futbol.jugador2.tarjetas_rojas = 0
        $script:futbol.balon.posicion = 50
        $script:futbol.balon.poseedor = 1
        $script:futbol.tiempo = 0
        $script:futbol.estadisticas = @{
            pases_j1 = 0
            pases_j2 = 0
            tiros_j1 = 0
            tiros_j2 = 0
            atajadas_j1 = 0
            atajadas_j2 = 0
        }
        
        Iniciar-Partido
    } else {
        Write-Host "`n¡Gracias por jugar fútbol!" -ForegroundColor Yellow
        Write-Host "Hasta pronto 👋" -ForegroundColor Cyan
    }
}

# Iniciar el juego
Show-MenuFutbol
