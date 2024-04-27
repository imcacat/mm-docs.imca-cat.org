#!/bin/sh
# POSIX-compliant script to process AsciiDoc files with asciidoctor.
# Users can specify either Ruby-based themes or YAML-based themes.

# Read-only variables
readonly HOME_PATH="/Users/jrgochan"
readonly CODE_PATH="$HOME_PATH/code"
readonly RCS_SITE_CHOICE=("github.com" "gitlab.com" "heptapod.host")

# Dynamically assigned variables
RCS_SITE="$CODE_PATH/github.com"  # Default RCS site
IMCA_CAT_PATH="$RCS_SITE/imca-cat"
DOCUMENTATION_PATH="$IMCA_CAT_PATH/documentation"
PROJECT_PATH="$DOCUMENTATION_PATH/docs.imca-cat.org"
DOCS_PATH="$PROJECT_PATH/docs"
DOCS_SRC_PATH="$DOCS_PATH/src"
DOCS_BUILD_PATH="$DOCS_PATH/build"
SKINS_PATH="$PROJECT_PATH/_sass/minimal-mistakes/skins"

# Set default document and theme paths
DEFAULT_DOC="$DOCS_SRC_PATH/colors.adoc"
THEME_PATH="$SKINS_PATH"  # Updated to point to skins directory
DEFAULT_THEME="$THEME_PATH/default"  # Placeholder for default skin

# Initialize variables
doc_path="$DEFAULT_DOC"
theme="$DEFAULT_THEME"
theme_type="ruby"  # 'ruby' or 'yaml'

CONFIG_FILE="$HOME_PATH/.asciidoctor_config.yml"

# Load settings from the config file if it exists
if [ -f "$CONFIG_FILE" ]; then
    eval "$(awk '/:/ {print $1$2}' $CONFIG_FILE)"
fi

# Function to show menu and handle user input for RCS site selection
select_rcs_site() {
    echo "Please select the RCS site:"
    select site in "${RCS_SITE_CHOICE[@]}"; do
        case $site in
            "github.com"|"gitlab.com"|"heptapod.host")
                RCS_SITE="$CODE_PATH/$site"
                IMCA_CAT_PATH="$RCS_SITE/imca-cat"
                DOCUMENTATION_PATH="$IMCA_CAT_PATH/documentation"
                PROJECT_PATH="$DOCUMENTATION_PATH/docs.imca-cat.org"
                DOCS_PATH="$PROJECT_PATH/docs"
                DOCS_SRC_PATH="$DOCS_PATH/src"
                DOCS_BUILD_PATH="$DOCS_PATH/build"
                SKINS_PATH="$PROJECT_PATH/_sass/minimal-mistakes/skins"
                THEME_PATH="$SKINS_PATH"
                echo "RCS site set to $site"
                break
                ;;
            *)
                echo "Invalid option. Please select a valid RCS site."
                ;;
        esac
    done
}

# Function to list and select themes from the THEME_PATH
select_theme() {
    echo "Available skins:"
    local skins=($(ls $THEME_PATH/* 2> /dev/null))
    select theme in "${skins[@]}" "Download more skins"; do
        case $theme in
            "Download more skins")
                echo "Enter URL to download skin:"
                read skin_url
                echo "Enter filename to save as (must end in proper file type):"
                read filename
                curl -s -o "$THEME_PATH/$filename" "$skin_url" && echo "Skin downloaded."
                theme="$THEME_PATH/$filename"
                ;;
            *)
                if [[ -n "$theme" ]]; then
                    echo "Selected skin: $theme"
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
options=("Select RCS Site" "Document Type" "Backend" "Safe Mode" "Select Theme" "Save and Continue")
select opt in "${options[@]}"; do
    case $opt in
        "Select RCS Site")
            select_rcs_site
            ;;
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
if [ -f "$CONFIG_FILE"an"
readonly CODE_PATH="$HOME_PATH/code"
readonly CONFIG_FILE="$HOME_PATH/.asciidoctor_config.yml"

# Function to select RCS site
select_rcs_site() {
    echo "Please select the RCS site:"
    select rcs in "github.com" "gitlab.com" "heptapod.host"; do
        case $rcs in
            "github.com"|"gitlab.com"|"heptapod.host")
                RCS_PATH="$CODE_PATH/$rcs"
                echo "RCS selected: $rcs"
                echo "rcs: $rcs" >> "$CONFIG_FILE"
                break
                ;;
            *)
                echo "Invalid option $REPLY, please choose a valid RCS site."
                ;;
        esac
    done
}

# Set the RCS path
select_rcs_site
readonly RCS_PATH

IMCA_CAT_PATH="$RCS_PATH/imca-cat"
DOCUMENTATION_PATH="$IMCA_CAT_PATH/documentation"
PROJECT_PATH="$DOCUMENTATION_PATH/docs.imca-cat.org"
DOCS_PATH="$PROJECT_PATH/docs"
DOCS_SRC_PATH="$DOCS_PATH/src"
DOCS_BUILD_PATH="$DOCS_PATH/build"

# Set default document and theme paths
DEFAULT_DOC="$DOCS_SRC_PATH/colors.adoc"
SKINS_PATH="$PROJECT_PATH/_sass/minimal-mistakes/skins"  # Base path for skins
DEFAULT_THEME="$SKINS_PATH/default.css"  # Default skin

# Initialize variables
doc_path="$DEFAULT_DOC"
theme="$DEFAULT_THEME"
theme_type="css"  # 'css' for skins

# Load settings from the config file if it exists
if [ -f "$CONFIG_FILE" ]; then
    eval "$(awk '/:/ {print $1$2}' $CONFIG_FILE)"
fi

# Function to list and select skins from the SKINS_PATH
select_skin() {
    echo "Available skins:"
    local skins=($(ls $SKINS_PATH/*.css 2> /dev/null))
    select skin in "${skins[@]}" "Download more skins"; do
        case $skin in
            "Download more skins")
                echo "Enter URL to download skin:"
                read skin_url
                echo "Enter filename to save as (must end in .css):"
                read filename
                curl -s -o "$SKINS_PATH/$filename" "$skin_url" && echo "Skin downloaded."
                skin="$SKINS_PATH/$filename"
                ;;
            *)
                if [[ -n "$skin" ]]; then
                    echo "Selected skin: $skin"
                    echo "skin: $skin" >> "$CONFIG_FILE"
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
options=("Document Type" "Backend" "Safe Mode" "Select Skin" "Save and Continue")
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
        "Select Skin")
            select_skin
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
DOC_PATH="${1:-$DEFAULT_DOC}"

# Execute Asciidoctor with all selected options
asciidoctor $asciidoctor_opts "$DOC_PATH"
echo "asciidoctor $asciidoctor_opts $DOC_PATH"
