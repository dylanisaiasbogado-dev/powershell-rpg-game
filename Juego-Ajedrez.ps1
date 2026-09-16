# ============================================
# PowerShell Chess Game - Para 2 Jugadores
# ============================================

# Inicializar el tablero de ajedrez
function Initialize-ChessBoard {
    $board = @()
    
    # Fila 8 (negras)
    $board += @(, @("♜", "♞", "♝", "♛", "♚", "♝", "♞", "♜"))
    # Fila 7 (peones negros)
    $board += @(, @("♟", "♟", "♟", "♟", "♟", "♟", "♟", "♟"))
    # Filas vacías
    for ($i = 0; $i -lt 4; $i++) {
        $board += @(, @(" ", " ", " ", " ", " ", " ", " ", " "))
    }
    # Fila 2 (peones blancos)
    $board += @(, @("♙", "♙", "♙", "♙", "♙", "♙", "♙", "♙"))
    # Fila 1 (blancas)
    $board += @(, @("♖", "♘", "♗", "♕", "♔", "♗", "♘", "♖"))
    
    return $board
}

# Variables del juego
$chess = @{
    board = Initialize-ChessBoard
    turno = 1  # 1 = Blancas, 2 = Negras
    juegoActivo = $true
    movimientos = @()
    capturadas_blancas = @()
    capturadas_negras = @()
    jugador1 = ""
    jugador2 = ""
    jaque = $false
    jaque_mate = $false
}

# Función para mostrar el tablero
function Show-ChessBoard {
    Clear-Host
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                    ♟️ AJEDREZ EN POWERSHELL ♟️                 ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    # Mostrar información del juego
    $turnoJugador = if ($script:chess.turno -eq 1) { "Blancas: $($script:chess.jugador1)" } else { "Negras: $($script:chess.jugador2)" }
    Write-Host "Turno: $turnoJugador" -ForegroundColor Yellow
    Write-Host "Movimientos totales: $($script:chess.movimientos.Count)" -ForegroundColor Cyan
    
    if ($script:chess.jaque) {
        Write-Host "⚠️  ¡JAQUE!" -ForegroundColor Red
    }
    
    Write-Host ""
    
    # Columnas (a-h)
    Write-Host "   A B C D E F G H" -ForegroundColor White
    Write-Host "  ╔═════════════════╗" -ForegroundColor White
    
    # Mostrar filas (8-1)
    for ($row = 0; $row -lt 8; $row++) {
        $filaNum = 8 - $row
        Write-Host "$filaNum ║" -NoNewline -ForegroundColor White
        
        for ($col = 0; $col -lt 8; $col++) {
            $pieza = $script:chess.board[$row][$col]
            
            # Colorear tablero alternado
            if (($row + $col) % 2 -eq 0) {
                Write-Host $pieza -NoNewline -BackgroundColor Gray -ForegroundColor Black
            } else {
                Write-Host $pieza -NoNewline -BackgroundColor White -ForegroundColor Black
            }
            Write-Host " " -NoNewline
        }
        
        Write-Host "║ $filaNum" -ForegroundColor White
    }
    
    Write-Host "  ╚═════════════════╝" -ForegroundColor White
    Write-Host "   A B C D E F G H" -ForegroundColor White
    Write-Host ""
    
    # Mostrar piezas capturadas
    Write-Host "Piezas Capturadas Blancas:" -ForegroundColor Yellow -NoNewline
    Write-Host " $($script:chess.capturadas_blancas -join ' ')" -ForegroundColor Red
    
    Write-Host "Piezas Capturadas Negras:" -ForegroundColor Yellow -NoNewline
    Write-Host " $($script:chess.capturadas_negras -join ' ')" -ForegroundColor Gray
    
    Write-Host ""
}

# Función para convertir coordenadas
function ConvertTo-Coordinates {
    param([string]$Input)
    
    if ($Input.Length -ne 2) {
        return $null
    }
    
    $col = [int]([char]$Input[0] - [char]'a')
    $row = 8 - [int]$Input[1]
    
    if ($col -lt 0 -or $col -gt 7 -or $row -lt 0 -or $row -gt 7) {
        return $null
    }
    
    return @($row, $col)
}

# Función para verificar si es pieza blanca
function Test-IsWhitePiece {
    param([string]$Pieza)
    
    $piezas_blancas = @("♔", "♕", "♖", "♗", "♘", "♙")
    return $piezas_blancas -contains $Pieza
}

# Función para verificar si es pieza negra
function Test-IsBlackPiece {
    param([string]$Pieza)
    
    $piezas_negras = @("♚", "♛", "♜", "♝", "♞", "♟")
    return $piezas_negras -contains $Pieza
}

# Función para validar movimiento
function Test-ValidMove {
    param(
        [int]$FromRow,
        [int]$FromCol,
        [int]$ToRow,
        [int]$ToCol
    )
    
    $pieza = $script:chess.board[$FromRow][$FromCol]
    $destino = $script:chess.board[$ToRow][$ToCol]
    
    # Verificar que sea pieza del jugador actual
    if ($script:chess.turno -eq 1 -and -not (Test-IsWhitePiece $pieza)) {
        return $false
    }
    
    if ($script:chess.turno -eq 2 -and -not (Test-IsBlackPiece $pieza)) {
        return $false
    }
    
    # Verificar que no capture pieza propia
    if ($script:chess.turno -eq 1 -and (Test-IsWhitePiece $destino)) {
        return $false
    }
    
    if ($script:chess.turno -eq 2 -and (Test-IsBlackPiece $destino)) {
        return $false
    }
    
    # Verificar que se mueva
    if ($FromRow -eq $ToRow -and $FromCol -eq $ToCol) {
        return $false
    }
    
    return $true
}

# Función para hacer un movimiento
function Make-Move {
    param(
        [string]$From,
        [string]$To
    )
    
    $fromCoords = ConvertTo-Coordinates $From
    $toCoords = ConvertTo-Coordinates $To
    
    if ($null -eq $fromCoords -or $null -eq $toCoords) {
        Write-Host "Coordenadas inválidas" -ForegroundColor Red
        return $false
    }
    
    $fromRow = $fromCoords[0]
    $fromCol = $fromCoords[1]
    $toRow = $toCoords[0]
    $toCol = $toCoords[1]
    
    if (-not (Test-ValidMove $fromRow $fromCol $toRow $toCol)) {
        Write-Host "Movimiento no válido" -ForegroundColor Red
        return $false
    }
    
    $pieza = $script:chess.board[$fromRow][$fromCol]
    $capturada = $script:chess.board[$toRow][$toCol]
    
    # Registrar captura
    if ($capturada -ne " ") {
        if ($script:chess.turno -eq 1) {
            $script:chess.capturadas_blancas += $capturada
        } else {
            $script:chess.capturadas_negras += $capturada
        }
    }
    
    # Hacer movimiento
    $script:chess.board[$fromRow][$fromCol] = " "
    $script:chess.board[$toRow][$toCol] = $pieza
    
    # Registrar movimiento
    $script:chess.movimientos += @{
        desde = $From
        hasta = $To
        pieza = $pieza
        capturada = $capturada
    }
    
    # Cambiar turno
    $script:chess.turno = if ($script:chess.turno -eq 1) { 2 } else { 1 }
    
    return $true
}

# Función para hacer deshacer
function Undo-Move {
    if ($script:chess.movimientos.Count -eq 0) {
        Write-Host "No hay movimientos que deshacer" -ForegroundColor Red
        return $false
    }
    
    $lastMove = $script:chess.movimientos[-1]
    $script:chess.movimientos = $script:chess.movimientos[0..($script:chess.movimientos.Count - 2)]
    
    $fromCoords = ConvertTo-Coordinates $lastMove.desde
    $toCoords = ConvertTo-Coordinates $lastMove.hasta
    
    # Restaurar piezas
    $script:chess.board[$fromCoords[0]][$fromCoords[1]] = $lastMove.pieza
    $script:chess.board[$toCoords[0]][$toCoords[1]] = $lastMove.capturada
    
    # Restaurar piezas capturadas
    if ($lastMove.capturada -ne " ") {
        if ($script:chess.turno -eq 2) {
            $script:chess.capturadas_blancas = $script:chess.capturadas_blancas[0..($script:chess.capturadas_blancas.Count - 2)]
        } else {
            $script:chess.capturadas_negras = $script:chess.capturadas_negras[0..($script:chess.capturadas_negras.Count - 2)]
        }
    }
    
    # Cambiar turno
    $script:chess.turno = if ($script:chess.turno -eq 1) { 2 } else { 1 }
    
    Write-Host "Movimiento deshecho" -ForegroundColor Green
    return $true
}

# Función del menú principal
function Show-MenuPrincipal {
    Clear-Host
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                                                                ║" -ForegroundColor Cyan
    Write-Host "║              ♟️ AJEDREZ EN POWERSHELL ♟️                      ║" -ForegroundColor Cyan
    Write-Host "║                                                                ║" -ForegroundColor Cyan
    Write-Host "║                 JUEGO PARA DOS JUGADORES                       ║" -ForegroundColor Cyan
    Write-Host "║                                                                ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "Ingresa el nombre del Jugador 1 (Blancas) 🤍" -ForegroundColor White
    $j1 = Read-Host "Nombre"
    $script:chess.jugador1 = $j1
    
    Write-Host ""
    Write-Host "Ingresa el nombre del Jugador 2 (Negras) ⚫" -ForegroundColor Black
    $j2 = Read-Host "Nombre"
    $script:chess.jugador2 = $j2
    
    Iniciar-Partida
}

# Función para iniciar partida
function Iniciar-Partida {
    while ($script:chess.juegoActivo) {
        Show-ChessBoard
        
        $turnoJugador = if ($script:chess.turno -eq 1) { $script:chess.jugador1 } else { $script:chess.jugador2 }
        Write-Host "Turno de: $turnoJugador" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Formato: a1b2 (desde-hasta)" -ForegroundColor Gray
        Write-Host "Comandos: 'deshacer' o 'salir'" -ForegroundColor Gray
        Write-Host ""
        
        $movimiento = Read-Host "Ingresa tu movimiento"
        
        switch ($movimiento.ToLower()) {
            "salir" {
                Write-Host "`n¿Estás seguro? (s/n)" -ForegroundColor Yellow
                if ((Read-Host).ToLower() -eq "s") {
                    $script:chess.juegoActivo = $false
                }
            }
            "deshacer" {
                Undo-Move
                Start-Sleep -Seconds 1
            }
            default {
                if ($movimiento.Length -eq 4) {
                    $from = $movimiento.Substring(0, 2)
                    $to = $movimiento.Substring(2, 2)
                    
                    if (Make-Move $from $to) {
                        Write-Host "✅ Movimiento válido" -ForegroundColor Green
                        Start-Sleep -Seconds 1
                    } else {
                        Write-Host "❌ Movimiento inválido" -ForegroundColor Red
                        Start-Sleep -Seconds 2
                    }
                } else {
                    Write-Host "Formato incorrecto" -ForegroundColor Red
                    Start-Sleep -Seconds 1
                }
            }
        }
    }
    
    # Pantalla final
    Clear-Host
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                  ¡JUEGO TERMINADO! 🏆                         ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "ESTADÍSTICAS:" -ForegroundColor Yellow
    Write-Host "Movimientos totales: $($script:chess.movimientos.Count)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Piezas Capturadas Blancas:" -ForegroundColor White
    Write-Host "$($script:chess.capturadas_blancas -join ' ')" -ForegroundColor Red
    Write-Host ""
    Write-Host "Piezas Capturadas Negras:" -ForegroundColor Black
    Write-Host "$($script:chess.capturadas_negras -join ' ')" -ForegroundColor Gray
    Write-Host ""
    Write-Host "¡Gracias por jugar ajedrez en PowerShell! 👋" -ForegroundColor Green
    Write-Host ""
}

# Iniciar el juego
Show-MenuPrincipal
