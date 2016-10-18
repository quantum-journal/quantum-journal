#!/usr/bin/env powershell
##
# install.ps1: Installs TeX resources to the current user's TeX directory.
##
# This file is part of quantumarticle.
#
#    Copyright (c) 2016 Verein zur Förderung des Open Access Publizierens in
#    den Quantenwissenschaften (http://quantum-journal.org/about/).
#    All rights reserved.
#
#    Redistribution and use in source and binary forms, with or without
#    modification, are permitted provided that the following conditions are
#    met:
#
#    1. Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#
#    2. Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#
#    3. Neither the name of quantumarticle, nor the names
#       of its contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
#    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
#    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
#    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
#    PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
#    HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#    SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
#    LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#    DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
#    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
#    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
##############################################################################

<#

.SYNOPSIS

    Installs the {quantumarticle} document class.

.DESCRIPTION

    This script installs the {quantumarticle} document class for use with
    either MiKTeX or TeX Live, and optionally installs templates for use with
    LyX and Pandoc.

.PARAMETER NoInstallTeXClass

    If set, disables installing the {quantumarticle} document class. This is
    useful if you only want to install support for other document processing
    tools.

.PARAMETER InstallPandocTemplate

    If set, installs a template for use with Pandoc into the current users'
    Pandoc data directory, as reported by "pandoc --version". This template
    can then be used with the "--template=quantumarticle" argument to pandoc,
    as in examples/pandoc/pandoc-example.md.

#>

## PARAMETERS ################################################################

param(
    [switch] $NoInstallTeXClass = $false,
    [switch] $InstallPandocTemplate = $false
);

## TYPES #####################################################################

try {
    Add-Type -TypeDefinition @"
       public enum TeXDistributions {
          MiKTeX, TeXLive, Other, None
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
    } elseif ($version_header.Contains("TeX Live")) {
        return [TeXDistributions]::TeXLive;
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

        "TeXLive" {
            return kpsewhich --expand-var='$TEXMFHOME';
        }

        "Other" {
            # Make a resonable guess if we can't figure out otherwise.
            return Resolve-Path "~/texmf";
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
    param(
        [TeXDistributions] $tex_dist = [TeXDistributions]::Other,
        [string] $tex_userdir = ""
    )
    
    switch ($tex_dist) {
        "MiKTeX" {
            initexmf --update-fndb;
            break;
        }

        "TeXLive" {
            texhash "$tex_userdir";
            break;
        }

        "Other" {
            texhash "$tex_userdir";
            break;
        }
    }

}

function assert_installed {
    param([string[]] $sources)

    # Filter out of kpsewhich the current directory (starts with "./",
    # even on operating systems with \ path separators).
    foreach ($source in $sources) {
        $which_output = kpsewhich -all -progname=pdflatex $source;
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

function find_pandoc_datadir {
    $pandoc_version = pandoc --version;

    foreach ($line in $pandoc_version.Split([environment]::NewLine)) {
        if ($line.Trim().StartsWith("Default user data directory:")) {
            $head, $tail = $line.Split(":", 2);
            return $tail.Trim();
        }
    }
}

## INSTALL SCRIPT ############################################################

if (-not $NoInstallTeXClass) {

    $tex_dist = detect_latex_distribution;
    if ($tex_dist -eq [TeXDistributions]::None) {
        throw [System.IO.FileNotFoundException] "No LaTeX distribution found. Aborting.";
    }

    $tex_userdir = find_tex_userdir -tex_dist $tex_dist;

    install_tex_resource -source "quantumarticle.cls" -tds_path "tex/latex/quantumarticle" -tex_userdir $tex_userdir;

    refresh_tex_hash -tex_dist $tex_dist;

    assert_installed "quantumarticle.cls";

    echo "All TeX resources installed successfully.";

}

if ($InstallPandocTemplate) {

    if (-not (which pandoc)) {
        throw [System.IO.FileNotFoundException] 'Pandoc is not installed on $PATH.';
    }

    $pandoc_datadir = find_pandoc_datadir;
    $pandoc_templatedir = Join-Path -Path $pandoc_datadir -ChildPath "templates";
    
    mkdir -Path $pandoc_templatedir -ErrorAction Ignore;

    cp "layouts/pandoc/quantumarticle.latex" $pandoc_templatedir;

}
