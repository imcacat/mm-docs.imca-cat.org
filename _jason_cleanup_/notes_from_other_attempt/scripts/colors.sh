#!/bin/sh
# POSIX-compliant script to process AsciiDoc files with asciidoctor.
# Users can specify either Ruby-based themes or YAML-based themes.

# Set base paths
HOME_PATH="/Users/jrgochan"
CODE_PATH="$HOME_PATH/code"
GITLAB_PATH="$CODE_PATH/gitlab.com"
IMCA_CAT_PATH="$GITLAB_PATH/imca-cat"
DOCUMENTATION_PATH="$IMCA_CAT_PATH/documentation"
PROJECT_PATH="$DOCUMENTATION_PATH/docs.imca-cat.org"
DOCS_PATH="$PROJECT_PATH/docs"
DOCS_SRC_PATH="$DOCS_PATH/src"
DOCS_BUILD_PATH="$DOCS_PATH/build"

# Set default document and theme paths
DEFAULT_DOC="$DOCS_SRC_PATH/colors.adoc"
THEME_PATH="$PROJECT_PATH/rogue_themes"  # Base path for themes
DEFAULT_THEME="$THEME_PATH/imca-cat.rb"  # Default theme

# Initialize variables
doc_path="$DEFAULT_DOC"
theme="$DEFAULT_THEME"
theme_type="ruby"  # 'ruby' or 'yaml'

CONFIG_FILE="$HOME_PATH/.asciidoctor_config.yml"

# Load settings from the config file if it exists
if [ -f "$CONFIG_FILE" ]; then
    eval "$(awk '/:/ {print $1$2}' $CONFIG_FILE)"
fi

# Function to show menu and handle user input for options
select_option() {
    echo "Please choose an option for $1:"
    select opt in "${@:2}"; do
        if [[ " ${@:2} " =~ " $opt " ]]; then
            echo "$1: $opt"
            echo "$1: $opt" >> "$CONFIG_FILE"
            break
        else
            echo "Invalid option $REPLY"
        fi
    done
}

# Function to list and select themes from the THEME_PATH
select_theme() {
    echo "Available themes:"
    local themes=($(ls $THEME_PATH/*.rb $THEME_PATH/*.yml 2> /dev/null))
    select theme in "${themes[@]}" "Download more themes"; do
        case $theme in
            "Download more themes")
                echo "Enter URL to download theme:"
                read theme_url
                echo "Enter filename to save as (must end in .rb or .yml):"
                read filename
                curl -s -o "$THEME_PATH/$filename" "$theme_url" && echo "Theme downloaded."
                theme="$THEME_PATH/$filename"
                ;;
            *)
                if [[ -n "$theme" ]]; then
                    echo "Selected theme: $theme"
                    echo "theme: $theme" >> "$CONFIG_FILE"
                    break
                else
                    echo "Invalid option $REPLY"
                fi
                ;;
        esac
    done
}

# Main menu
echo "Welcome to the Asciidoctor configuration script. Please select your preferences for document processing:"
PS3="Enter your choice: "
options=("Document Type" "Backend" "Safe Mode" "Select Theme" "Save and Continue")
select opt in "${options[@]}"; do
    case $opt in
        "Document Type")
            select_option "doctype" "article" "book" "manpage" "inline"
            ;;
        "Backend")
            select_option "backend" "html5" "xhtml5" "docbook5" "pdf" "manpage"
            ;;
        "Safe Mode")
            select_option "safe-mode" "safe" "unsafe" "server" "secure"
            ;;
        "Select Theme")
            select_theme
            ;;
        "Save and Continue")
            echo "Settings saved to $CONFIG_FILE"
            break
            ;;
        *) echo "Invalid option $REPLY";;
    esac
done

# Load configurations
if [ -f "$CONFIG_FILE" ]; then
    while IFS=: read -r key value
    do
        asciidoctor_opts="$asciidoctor_opts -a $key=$value"
    done < "$CONFIG_FILE"
fi

# Set default document path if not specified in options
DOC_PATH="${1:-$DOCS_SRC_PATH/colors.adoc}"

# Execute Asciidoctor with all selected options
asciidoctor $asciidoctor_opts "$DOC_PATH"
echo "asciidoctor $asciidoctor_opts $DOC_PATH"
