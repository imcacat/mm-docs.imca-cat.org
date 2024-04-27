#!/bin/sh
# POSIX-compliant script to process AsciiDoc files with asciidoctor.
# Users can specify either Ruby-based themes or YAML-based themes.

readonly RCS_CHOICES="github.com gitlab.com heptapod.host"
readonly DEFAULT_RCS="github.com"

# Set base paths
readonly HOME_PATH="/Users/jrgochan"
readonly CODE_PATH="$HOME_PATH/code"
readonly GITLAB_PATH="$CODE_PATH/gitlab.com"
readonly IMCA_CAT_PATH="$GITLAB_PATH/imca-cat"
readonly DOCUMENTATION_PATH="$IMCA_CAT_PATH/documentation"
readonly PROJECT_PATH="$DOCUMENTATION_PATH/docs.imca-cat.org"
readonly DOCS_PATH="$PROJECT_PATH/docs"
readonly DOCS_SRC_PATH="$DOCS_PATH/src"
readonly DOCS_BUILD_PATH="$DOCS_PATH/build"

# Set default document and theme paths
readonly DEFAULT_DOC="$DOCS_SRC_PATH/colors.adoc"
readonly THEME_PATH="$PROJECT_PATH/rogue_themes"  # Base path for themes
readonly DEFAULT_THEME="$THEME_PATH/imca-cat.rb"  # Default theme

# Initialize variables
doc_path="$DEFAULT_DOC"
theme="$DEFAULT_THEME"
theme_type="ruby"  # 'ruby' or 'yaml'

readonly CONFIG_FILE="$HOME_PATH/.asciidoctor_config.yml"

# Load settings from the config file if it exists
if [ -f "$CONFIG_FILE" ]; then
    . "$CONFIG_FILE"
fi

# Function to show menu and handle user input for options
select_option() {
    echo "Please choose an option for $1:"
    select opt in "${@:2}"; do
        if [ "$opt" ]; then
            echo "$1: $opt"
            eval "$1='$opt'"
            break
        else
            echo "Invalid option $REPLY"
        fi
    done
}

# Function to list and select themes from the THEME_PATH
select_theme() {
    echo "Available themes:"
    local themes=($(ls "$THEME_PATH"/*.rb "$THEME_PATH"/*.yml 2> /dev/null))
    select theme in "${themes[@]}" "Download more themes"; do
        case $theme in
            "Download more themes")
                echo "Enter URL to download theme:"
                read -r theme_url
                echo "Enter filename to save as (must end in .rb or .yml):"
                read -r filename
                curl -s -o "$THEME_PATH/$filename" "$theme_url" && echo "Theme downloaded."
                theme="$THEME_PATH/$filename"
                ;;
            *)
                if [ "$theme" ]; then
                    echo "Selected theme: $theme"
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
            select_option "doc_type" "article" "book" "manpage" "inline"
            ;;
        "Backend")
            select_option "backend" "html5" "xhtml5" "docbook5" "pdf" "manpage"
            ;;
        "Safe Mode")
            select_option "safe_mode" "safe" "unsafe" "server" "secure"
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

# Save configurations
echo "doc_type='$doc_type'" > "$CONFIG_FILE"
echo "backend='$backend'" >> "$CONFIG_FILE"
echo "safe_mode='$safe_mode'" >> "$CONFIG_FILE"
echo "theme='$theme'" >> "$CONFIG_FILE"

# Set default document path if not specified in options
DOC_PATH="${1:-$DOCS_SRC_PATH/colors.adoc}"

# Execute Asciidoctor with all selected options
asciidoctor -a "doc_type=$doc_type" -a "backend=$backend" -a "safe_mode=$safe_mode" -a "theme=$theme" "$DOC_PATH"
echo "asciidoctor -a 'doc_type=$doc_type' -a 'backend=$backend' -a 'safe_mode=$safe_mode' -a 'theme=$theme' '$DOC_PATH'"
