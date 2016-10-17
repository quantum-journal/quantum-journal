#!/usr/bin/env bash
##
# install.sh: Installs TeX resources to the current user's TeX directory.
##

## NOTES #####################################################################

# We use the idiom documented at
#     https://www.linuxjournal.com/content/return-values-bash-functions
# to implement functions with "return values," with the convention that
# the first argument ($1) to each function is the name of a variable to
# write the result into.

## FUNCTIONS #################################################################

function detect_latex_distribution() {
    local __ret_variable=$1

    if [[ -z `which latex` ]]; then
        eval $__ret_variable="None"
        return 0
    fi

    local version_header="$(pdflatex --version | head -n 1)"

    if [[ $version_header == *"MiKTeX"* ]]; then
        eval $__ret_variable="MiKTeX"
        return 0
    elif [[ $version_header == *"TeX Live"* ]]; then
        eval $__ret_variable="'TeX Live'"
        return 0
    else
        eval $__ret_variable="Other"
        return 0
    fi
}

function find_tex_userdir() {
    local __ret_variable=$1
    local tex_dist=$2

    local where_temp=mktemp

    if [[ $tex_dist == "MiKTeX" ]]; then
        initexmf --report | while read -r line
        do
            if [[ $line == *":"* ]]; then
                if [[ $line =~ 'UserInstall:'(.*) ]]; then
                    local ret_val="$(echo "$line" | sed -e 's/UserInstall: //')"
                    printf '%s\n' "$ret_val" > $where_temp
                fi
            fi
        done

        # See https://stackoverflow.com/a/9715377 for why this works.
        # Specifically, we need the \$ to force escaping of all backslashes.
        # We may be running under Windows (someone ran bash on Windows to
        # install a TeX resource? the monster!), such that we must be robust
        # to \ use here.
        # Brief addendum: this is ugly beyond all that should ever be permissible.
        # I'd love a better way to do this.
        eval $__ret_variable="\$(cat $where_temp)"
        rm $where_temp
        return 0

    elif [[ $tex_dist == 'TeX Live' ]]; then
        eval $__ret_variable="$(kpsewhich --expand-var=\$TEXMFHOME)"
        return 0
    elif [[ $tex_dist == "Other" ]]; then
        eval $__ret_variable="~/texmf/"
        return 0
    fi

}

function install_tex_resource() {
    # No "return" value, so no __ret_variable needed.

    local source="$1"
    local tds_path="$2"
    local tex_userdir="$3"

    local dest="$tex_userdir/$tds_path";
    mkdir -p "$dest"
    cp "$source" "$dest"

}

function refresh_tex_hash {
    # No "return" value, so no __ret_variable needed.

    local tex_dist="$1"
    local tex_userdir="$2"
    
    if [[ $tex_dist == "MiKTeX" ]]; then
        initexmf --update-fndb
    elif [[ $tex_dist == "Other" ]] || [[ $tex_dist == 'TeX Live' ]]; then
        texhash "$tex_userdir"
    fi
    
}

function assert_installed() {
    # No "return" value, so no __ret_variable needed.
    local source="$1"

    # NB: this is *not* a direct analogy to the function in
    #     install.ps1, as it does not support multiple arguments at
    #     once.

    # Filter out of kpsewhich the current directory (starts with "./",
    # even on operating systems with \ path separators).

    kpsewhich -all -progname=pdflatex "$source" | while read -r line
    do
        if [[ $line != "./"* ]]; then
            return 42
            break
        fi
    done

    local found=$?

    if [[ $found == 0 ]]; then
        echo "TeX resource $source did not install correctly."
        return -1
    elif [[ $found == 42 ]]; then
        return 0
    else
        echo $found
        echo "Something rather unexpected happened, probably related to while loops being weird."
        return -9
    fi
}


## MAIN ######################################################################

function main() {

    detect_latex_distribution tex_dist

    if [[ $tex_dist == "None" ]]; then
        echo "No LaTeX distribution found."
        return -1
    fi

    echo "Using TeX distribution $tex_dist."

    find_tex_userdir tex_userdir "$tex_dist"
    echo "Using TeX user directory $tex_userdir."
    install_tex_resource quantumarticle.cls tex/latex/quantumarticle "$tex_userdir"

    refresh_tex_hash "$tex_dist" "$tex_userdir"

    assert_installed quantumarticle.cls

    if [[ $? == 0 ]]; then
        echo "All TeX resources installed successfully."
    fi

}

main
