# Amor-Para-Claudia.ps1
# Mensaje de Dylan para Claudia 💖

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Clear-Host

$rosa = [ConsoleColor]::Magenta
$rojo = [ConsoleColor]::Red
$blanco = [ConsoleColor]::White
$amarillo = [ConsoleColor]::Yellow

function Escribir-Centro {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Texto,
        [ConsoleColor]$Color = [ConsoleColor]::White
    )

    $ancho = [Math]::Max(0, [Console]::WindowWidth - 1)
    $linea = $Texto.PadLeft([Math]::Max(0, [int](($ancho + $Texto.Length) / 2)))
    Write-Host $linea -ForegroundColor $Color
}

function Escribir-Lento {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Texto,
        [ConsoleColor]$Color = [ConsoleColor]::White,
        [int]$Milisegundos = 28
    )

    foreach ($caracter in $Texto.ToCharArray()) {
        Write-Host -NoNewline $caracter -ForegroundColor $Color
        Start-Sleep -Milliseconds $Milisegundos
    }
    Write-Host
}

$corazon = '♥'
$decoracion = ($corazon * 3) + '  ' + ($corazon * 3)

Write-Host ''
Escribir-Centro $decoracion $rojo
Escribir-Centro '╔══════════════════════════════════════════════╗' $rosa
Escribir-Centro '║            💌  PARA CLAUDIA  💌             ║' $rosa
Escribir-Centro '╚══════════════════════════════════════════════╝' $rosa
Escribir-Centro $decoracion $rojo
Write-Host ''

Escribir-Centro 'Claudia, eres mi persona favorita.' $amarillo
Start-Sleep -Milliseconds 700
Escribir-Centro 'Tu sonrisa ilumina incluso mis días más grises.' $blanco
Start-Sleep -Milliseconds 700
Escribir-Centro 'Cada momento contigo se convierte en un recuerdo precioso.' $blanco
Start-Sleep -Milliseconds 700
Write-Host ''

Escribir-Lento 'Con todo mi cariño, te digo...' $rosa 35
Write-Host ''
Escribir-Centro 'TE QUIERO MUCHÍSIMO, CLAUDIA' $rojo
Escribir-Centro '♥  ♥  ♥  ♥  ♥  ♥  ♥  ♥  ♥  ♥' $rojo
Write-Host ''
Escribir-Centro 'Siempre tuyo, Dylan ✨' $amarillo
Write-Host ''
Escribir-Centro $decoracion $rojo

Read-Host 'Presiona ENTER para cerrar'
