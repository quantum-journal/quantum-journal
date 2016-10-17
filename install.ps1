#!/usr/bin/env powershell
##
# install.ps1: Installs TeX resources to the current user's TeX directory.
##

## TYPES #####################################################################

try {
    Add-Type -TypeDefinition @"
       public enum TeXDistributions {
          MiKTeX, Other, None
       }
"@
} catch {}

## FUNCTIONS  ################################################################

function which {
    param([string] $name)

    try {
        Get-Command $name -ErrorAction Stop | Select-Object -ExpandProperty Definition
    } catch {
        return $null;
    }
}

function detect_latex_distribution() {
    if (!(which("latex"))) {
        return [TeXDistributions]::None;
    }

    $version_output = pdflatex --version;
    $version_header =  $version_output.Split([environment]::NewLine)[0];

    if ($version_header.Contains("MiKTeX")) {
        return [TeXDistributions]::MiKTeX;
    } else {
        return [TeXDistributions]::Other;
    }
}

function find_tex_userdir {
    param([TeXDistributions] $tex_dist = [TeXDistributions]::Other)

    switch ($tex_dist) {
        "MiKTeX" {
            $miktex_report = initexmf --report;

            foreach ($report_line in $miktex_report.Split([environment]::NewLine)) {
                if ($report_line.Contains(":")) {
                    $key, $value = $report_line.Split(":", 2);
                    if ($key.ToLower().Trim() -eq "userinstall") {
                        return $value.Trim();
                    }
                }
            }

            throw [System.IO.FileNotFoundException] "No MiKTeX user install directory found.";
        }

        "Other" {
            echo "finding texdir some other way.";
            break;
        }
    }

}

function install_tex_resource {
    param([string]$source, [string]$tds_path, [string]$tex_userdir)

    $dest = Join-Path -Path $tex_userdir -ChildPath $tds_path;

    # First make sure the TDS path exists.
    New-Item -ItemType Directory -Path $dest -ErrorAction Ignore;

    # Next, copy the file into the TeX directory.
    Copy-Item -Path $source -Destination $dest;

}

function refresh_tex_hash {
    param([TeXDistributions] $tex_dist = [TeXDistributions]::Other)
    
    switch ($tex_dist) {
        "MiKTeX" {
            initexmf --update-fndb;
            break;
        }

        "Other" {
            texhash -R;
            break;
        }
    }

}

function assert_installed {
    param([string[]] $sources)

    # Filter out of kpsewhich the current directory (starts with "./",
    # even on operating systems with \ path separators).
    foreach ($source in $sources) {
        $which_output = kpsewhich -all $source;
        $found = $false;

        foreach ($which_line in $which_output.Split([environment]::NewLine)) {
            if (-not $which_line.StartsWith("./")) {
                $found = $true;
            }
        }

        if (-not $found) {
            throw [System.IO.FileNotFoundException] "TeX resource $source not installed sucessfully.";
        }
    }
}

## INSTALL SCRIPT ############################################################

$tex_dist = detect_latex_distribution;
if ($tex_dist -eq [TeXDistributions]::None) {
    throw [System.IO.FileNotFoundException] "No LaTeX distribution found. Aborting.";
}

$tex_userdir = find_tex_userdir -tex_dist $tex_dist;

install_tex_resource -source "quantumarticle.cls" -tds_path "tex/latex/quantumarticle" -tex_userdir $tex_userdir;

refresh_tex_hash -tex_dist $tex_dist;

assert_installed "quantumarticle.cls";

echo "All TeX resources installed successfully.";
