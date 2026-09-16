# ============================================
# PowerShell Tetris Game
# ============================================

# Configuración del juego
$juego = @{
    ancho = 10
    alto = 20
    campo = @()
    pieza_actual = $null
    pieza_siguiente = $null
    puntos = 0
    lineas = 0
    nivel = 1
    velocidad = 200
    juegoActivo = $true
    x_pieza = 0
    y_pieza = 0
}

# Definición de piezas de Tetris
$piezas = @{
    I = @{
        forma = @(
            @(0, 0, 0, 0),
            @(1, 1, 1, 1),
            @(0, 0, 0, 0),
            @(0, 0, 0, 0)
        )
        color = "Cyan"
    }
    O = @{
        forma = @(
            @(1, 1),
            @(1, 1)
        )
        color = "Yellow"
    }
    T = @{
        forma = @(
            @(0, 1, 0),
            @(1, 1, 1),
            @(0, 0, 0)
        )
        color = "Magenta"
    }
    S = @{
        forma = @(
            @(0, 1, 1),
            @(1, 1, 0),
            @(0, 0, 0)
        )
        color = "Green"
    }
    Z = @{
        forma = @(
            @(1, 1, 0),
            @(0, 1, 1),
            @(0, 0, 0)
        )
        color = "Red"
    }
    J = @{
        forma = @(
            @(1, 0, 0),
            @(1, 1, 1),
            @(0, 0, 0)
        )
        color = "Blue"
    }
    L = @{
        forma = @(
            @(0, 0, 1),
            @(1, 1, 1),
            @(0, 0, 0)
        )
        color = "DarkYellow"
    }
}

# Función para inicializar el campo
function Inicializar-Campo {
    $script:juego.campo = @()
    for ($i = 0; $i -lt $script:juego.alto; $i++) {
        $fila = @()
        for ($j = 0; $j -lt $script:juego.ancho; $j++) {
            $fila += 0
        }
        $script:juego.campo += @(, $fila)
    }
}

# Función para obtener una pieza aleatoria
function Get-PiezaAleatoria {
    $keys = $piezas.Keys | Get-Random
    return @{
        tipo = $keys
        forma = $piezas[$keys].forma
        color = $piezas[$keys].color
    }
}

# Función para dibujar el campo
function Dibujar-Campo {
    Clear-Host
    
    Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║           🎮 TETRIS EN POWERSHELL 🎮     ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    # Mostrar el campo
    Write-Host "┌" -NoNewline -ForegroundColor White
    for ($i = 0; $i -lt $script:juego.ancho; $i++) {
        Write-Host "─" -NoNewline -ForegroundColor White
    }
    Write-Host "┐" -ForegroundColor White
    
    for ($y = 0; $y -lt $script:juego.alto; $y++) {
        Write-Host "│" -NoNewline -ForegroundColor White
        
        for ($x = 0; $x -lt $script:juego.ancho; $x++) {
            if ($script:juego.campo[$y][$x] -eq 0) {
                Write-Host " " -NoNewline
            } else {
                Write-Host "█" -NoNewline -ForegroundColor $script:juego.campo[$y][$x]
            }
        }
        
        Write-Host "│" -ForegroundColor White
    }
    
    Write-Host "└" -NoNewline -ForegroundColor White
    for ($i = 0; $i -lt $script:juego.ancho; $i++) {
        Write-Host "─" -NoNewline -ForegroundColor White
    }
    Write-Host "┘" -ForegroundColor White
    
    # Mostrar siguiente pieza
    Write-Host ""
    Write-Host "SIGUIENTE PIEZA:" -ForegroundColor Yellow
    Write-Host "┌───────┐" -ForegroundColor White
    foreach ($fila in $script:juego.pieza_siguiente.forma) {
        Write-Host "│" -NoNewline -ForegroundColor White
        foreach ($celda in $fila) {
            if ($celda -eq 0) {
                Write-Host " " -NoNewline
            } else {
                Write-Host "█" -NoNewline -ForegroundColor $script:juego.pieza_siguiente.color
            }
        }
        Write-Host "│" -ForegroundColor White
    }
    Write-Host "└───────┘" -ForegroundColor White
    
    # Mostrar estadísticas
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Yellow
    Write-Host "║ PUNTOS: $($script:juego.puntos.ToString().PadRight(28)) ║" -ForegroundColor Yellow
    Write-Host "║ LÍNEAS: $($script:juego.lineas.ToString().PadRight(28)) ║" -ForegroundColor Yellow
    Write-Host "║ NIVEL: $($script:juego.nivel.ToString().PadRight(29)) ║" -ForegroundColor Yellow
    Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Yellow
    
    Write-Host ""
    Write-Host "CONTROLES:" -ForegroundColor Green
    Write-Host "← → = Mover" -ForegroundColor White
    Write-Host "↓   = Bajar" -ForegroundColor White
    Write-Host "ESPACIO = Rotar" -ForegroundColor White
    Write-Host "P = Pausa" -ForegroundColor White
    Write-Host "Q = Salir" -ForegroundColor White
}

# Función para verificar si una posición es válida
function Test-Posicion {
    param(
        [int]$x,
        [int]$y,
        [array]$forma
    )
    
    $alto_forma = $forma.Count
    $ancho_forma = $forma[0].Count
    
    for ($fy = 0; $fy -lt $alto_forma; $fy++) {
        for ($fx = 0; $fx -lt $ancho_forma; $fx++) {
            if ($forma[$fy][$fx] -eq 1) {
                $py = $y + $fy
                $px = $x + $fx
                
                # Verificar límites
                if ($px -lt 0 -or $px -ge $script:juego.ancho -or $py -ge $script:juego.alto) {
                    return $false
                }
                
                # Verificar colisión con bloques existentes
                if ($py -ge 0 -and $script:juego.campo[$py][$px] -ne 0) {
                    return $false
                }
            }
        }
    }
    
    return $true
}

# Función para colocar una pieza en el campo
function Colocar-Pieza {
    param(
        [int]$x,
        [int]$y,
        [array]$forma,
        [string]$color
    )
    
    $alto_forma = $forma.Count
    $ancho_forma = $forma[0].Count
    
    for ($fy = 0; $fy -lt $alto_forma; $fy++) {
        for ($fx = 0; $fx -lt $ancho_forma; $fx++) {
            if ($forma[$fy][$fx] -eq 1) {
                $py = $y + $fy
                $px = $x + $fx
                
                if ($py -ge 0 -and $py -lt $script:juego.alto -and $px -ge 0 -and $px -lt $script:juego.ancho) {
                    $script:juego.campo[$py][$px] = $color
                }
            }
        }
    }
}

# Función para rotar una pieza
function Rotar-Pieza {
    param(
        [array]$forma
    )
    
    $n = $forma.Count
    $m = $forma[0].Count
    $rotada = @()
    
    for ($j = 0; $j -lt $m; $j++) {
        $fila = @()
        for ($i = $n - 1; $i -ge 0; $i--) {
            $fila += $forma[$i][$j]
        }
        $rotada += @(, $fila)
    }
    
    return $rotada
}

# Función para eliminar líneas completas
function Eliminar-Lineas {
    $lineas_eliminadas = 0
    $y = $script:juego.alto - 1
    
    while ($y -ge 0) {
        $completa = $true
        
        for ($x = 0; $x -lt $script:juego.ancho; $x++) {
            if ($script:juego.campo[$y][$x] -eq 0) {
                $completa = $false
                break
            }
        }
        
        if ($completa) {
            $lineas_eliminadas++
            # Eliminar la línea
            $script:juego.campo.RemoveAt($y)
            # Agregar nueva línea vacía al inicio
            $nueva_fila = @()
            for ($x = 0; $x -lt $script:juego.ancho; $x++) {
                $nueva_fila += 0
            }
            $script:juego.campo.Insert(0, @(, $nueva_fila))
        } else {
            $y--
        }
    }
    
    if ($lineas_eliminadas -gt 0) {
        $script:juego.lineas += $lineas_eliminadas
        $script:juego.puntos += $lineas_eliminadas * 100 * $script:juego.nivel
        $script:juego.nivel = [int]($script:juego.lineas / 10) + 1
        $script:juego.velocidad = [int](200 - ($script:juego.nivel * 10))
        if ($script:juego.velocidad -lt 50) { $script:juego.velocidad = 50 }
    }
}

# Función para procesador de entrada
function Procesar-Entrada {
    if ([Console]::KeyAvailable) {
        $key = [Console]::ReadKey($true)
        
        switch ($key.Key) {
            "LeftArrow" {
                if (Test-Posicion ($script:juego.x_pieza - 1) $script:juego.y_pieza $script:juego.pieza_actual.forma) {
                    $script:juego.x_pieza--
                }
            }
            "RightArrow" {
                if (Test-Posicion ($script:juego.x_pieza + 1) $script:juego.y_pieza $script:juego.pieza_actual.forma) {
                    $script:juego.x_pieza++
                }
            }
            "DownArrow" {
                if (Test-Posicion $script:juego.x_pieza ($script:juego.y_pieza + 1) $script:juego.pieza_actual.forma) {
                    $script:juego.y_pieza++
                    $script:juego.puntos += 1
                }
            }
            "Spacebar" {
                $nueva_forma = Rotar-Pieza $script:juego.pieza_actual.forma
                if (Test-Posicion $script:juego.x_pieza $script:juego.y_pieza $nueva_forma) {
                    $script:juego.pieza_actual.forma = $nueva_forma
                }
            }
            "P" {
                Pausa-Juego
            }
            "Q" {
                $script:juego.juegoActivo = $false
            }
        }
    }
}

# Función para pausa
function Pausa-Juego {
    Write-Host "`n⏸️  JUEGO EN PAUSA" -ForegroundColor Yellow
    Write-Host "Presiona Enter para continuar..." -ForegroundColor Yellow
    Read-Host
}

# Función principal del juego
function Iniciar-Tetris {
    Clear-Host
    
    Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║      ¡BIENVENIDO A TETRIS EN POWERSHELL!  ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "El juego comenzará en..." -ForegroundColor Green
    Write-Host "3" -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Write-Host "2" -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Write-Host "1" -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    
    Inicializar-Campo
    
    # Crear primera pieza
    $script:juego.pieza_actual = Get-PiezaAleatoria
    $script:juego.pieza_siguiente = Get-PiezaAleatoria
    $script:juego.x_pieza = [int](($script:juego.ancho - 4) / 2)
    $script:juego.y_pieza = 0
    
    $tiempo_anterior = Get-Date
    
    while ($script:juego.juegoActivo) {
        # Calcular tiempo transcurrido
        $tiempo_actual = Get-Date
        $tiempo_transcurrido = ($tiempo_actual - $tiempo_anterior).TotalMilliseconds
        
        # Dibujar el campo
        Dibujar-Campo
        
        # Dibujar pieza actual con color
        $temp_campo = @()
        for ($i = 0; $i -lt $script:juego.campo.Count; $i++) {
            $temp_campo += @(, $script:juego.campo[$i].Clone())
        }
        
        Colocar-Pieza $script:juego.x_pieza $script:juego.y_pieza $script:juego.pieza_actual.forma $script:juego.pieza_actual.color
        Dibujar-Campo
        
        # Restaurar el campo
        $script:juego.campo = $temp_campo
        
        # Procesar entrada del usuario
        Procesar-Entrada
        
        # Mover pieza hacia abajo automáticamente
        if ($tiempo_transcurrido -ge $script:juego.velocidad) {
            if (Test-Posicion $script:juego.x_pieza ($script:juego.y_pieza + 1) $script:juego.pieza_actual.forma) {
                $script:juego.y_pieza++
            } else {
                # Colocar pieza en el campo
                Colocar-Pieza $script:juego.x_pieza $script:juego.y_pieza $script:juego.pieza_actual.forma $script:juego.pieza_actual.color
                
                # Eliminar líneas completas
                Eliminar-Lineas
                
                # Verificar si el juego terminó
                if ($script:juego.y_pieza -lt 2 -and -not (Test-Posicion $script:juego.x_pieza 0 $script:juego.pieza_siguiente.forma)) {
                    $script:juego.juegoActivo = $false
                } else {
                    # Siguiente pieza
                    $script:juego.pieza_actual = $script:juego.pieza_siguiente
                    $script:juego.pieza_siguiente = Get-PiezaAleatoria
                    $script:juego.x_pieza = [int](($script:juego.ancho - 4) / 2)
                    $script:juego.y_pieza = 0
                }
            }
            
            $tiempo_anterior = $tiempo_actual
        }
        
        Start-Sleep -Milliseconds 50
    }
    
    # Mostrar pantalla de fin de juego
    Clear-Host
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Red
    Write-Host "║         ¡JUEGO TERMINADO! 💀            ║" -ForegroundColor Red
    Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Red
    Write-Host ""
    Write-Host "PUNTUACIÓN FINAL" -ForegroundColor Yellow
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
    Write-Host "Puntos:  $($script:juego.puntos)" -ForegroundColor Green
    Write-Host "Líneas:  $($script:juego.lineas)" -ForegroundColor Green
    Write-Host "Nivel:   $($script:juego.nivel)" -ForegroundColor Green
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
    Write-Host ""
    
    Write-Host "¿Quieres jugar de nuevo?" -ForegroundColor Green
    Write-Host "1) Sí" -ForegroundColor White
    Write-Host "2) No" -ForegroundColor White
    
    $opcion = Read-Host "Elige (1-2)"
    
    if ($opcion -eq "1") {
        # Reiniciar juego
        $script:juego.puntos = 0
        $script:juego.lineas = 0
        $script:juego.nivel = 1
        $script:juego.velocidad = 200
        $script:juego.juegoActivo = $true
        Iniciar-Tetris
    } else {
        Write-Host "`n¡Gracias por jugar Tetris!" -ForegroundColor Yellow
        Write-Host "Hasta pronto 👋" -ForegroundColor Cyan
    }
}

# Iniciar el juego
Iniciar-Tetris
