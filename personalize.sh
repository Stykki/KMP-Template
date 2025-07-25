#!/bin/bash

# Script to personalize a KMP Template project
# Changes application name and package ID throughout the project

# Color codes for better readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Get the project root directory
ROOT_DIR=$(pwd)

# Parse command line arguments
DRY_RUN=false
for arg in "$@"; do
    case $arg in
        --dry-run|-d)
            DRY_RUN=true
            shift
            ;;
    esac
done

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}DRY RUN MODE: No changes will be made${NC}"
    echo -e "${YELLOW}This will only show what would be changed${NC}\n"
fi

echo -e "${BLUE}KMP Template Personalization Script${NC}"
echo -e "${BLUE}====================================${NC}\n"

# Original values
ORIGINAL_APP_NAME="KotlinApplicationTemplate"
ORIGINAL_APP_NAME_LOWER=$(echo "$ORIGINAL_APP_NAME" | tr '[:upper:]' '[:lower:]')
ORIGINAL_PACKAGE_ID="com.example.kotlin.application.template"
ORIGINAL_PACKAGE_PATH="com/example/kotlin/application/template"

# Get new application name
read -p "Enter new application name (PascalCase, no spaces): " NEW_APP_NAME
if [ -z "$NEW_APP_NAME" ]; then
    echo -e "${RED}Error: Application name cannot be empty${NC}"
    exit 1
fi
NEW_APP_NAME_LOWER=$(echo "$NEW_APP_NAME" | tr '[:upper:]' '[:lower:]')

# Validate app name (PascalCase, alphanumeric)
if ! [[ $NEW_APP_NAME =~ ^[A-Z][a-zA-Z0-9]*$ ]]; then
    echo -e "${RED}Error: Application name must be in PascalCase (start with uppercase, no spaces or special characters)${NC}"
    exit 1
fi

# Get new package ID
read -p "Enter new package ID (e.g., com.yourcompany.appname): " NEW_PACKAGE_ID
if [ -z "$NEW_PACKAGE_ID" ]; then
    echo -e "${RED}Error: Package ID cannot be empty${NC}"
    exit 1
fi

# Validate package ID (standard Java package format)
if ! [[ $NEW_PACKAGE_ID =~ ^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)*$ ]]; then
    echo -e "${RED}Error: Package ID must be in standard format (e.g., com.yourcompany.appname)${NC}"
    exit 1
fi

# Convert package ID to path format
NEW_PACKAGE_PATH=$(echo $NEW_PACKAGE_ID | sed 's/\./\//g')

echo -e "\n${GREEN}Personalizing your KMP project...${NC}\n"
echo -e "App Name: ${YELLOW}$ORIGINAL_APP_NAME${NC} → ${GREEN}$NEW_APP_NAME${NC}"
echo -e "Generated App Name: ${YELLOW}$ORIGINAL_APP_NAME_LOWER${NC} → ${GREEN}$NEW_APP_NAME_LOWER${NC}"
echo -e "Package ID: ${YELLOW}$ORIGINAL_PACKAGE_ID${NC} → ${GREEN}$NEW_PACKAGE_ID${NC}"
echo -e "Package Path: ${YELLOW}$ORIGINAL_PACKAGE_PATH${NC} → ${GREEN}$NEW_PACKAGE_PATH${NC}\n"

# Function to replace text in files
replace_in_files() {
    echo -e "${BLUE}Replacing text in files...${NC}"
    
    # Initialize a total counter
    TOTAL_MODIFIED_FILES=0
    TOTAL_APP_NAME_COUNT=0
    TOTAL_PACKAGE_ID_COUNT=0
    
    # Replace app name and package ID in all files
    find "$ROOT_DIR" -type f -not -path "*/\.*" -not -path "*/build/*" -not -path "*/\.gradle/*" -not -path "*/\.idea/*" | while read file; do
        if [ -f "$file" ] && [ ! -L "$file" ]; then
            # Skip binary files
            if file "$file" | grep -q "binary"; then
                continue
            fi
            
            # Use grep to safely count occurrences
            APP_NAME_MATCHES=0
            if grep -q "$ORIGINAL_APP_NAME" "$file" 2>/dev/null; then
                APP_NAME_MATCHES=$(grep -o "$ORIGINAL_APP_NAME" "$file" 2>/dev/null | wc -l | tr -d '[:space:]')
            fi

            # Use grep to safely count occurrences
            APP_NAME_LOWER_MATCHES=0
            if grep -q "$ORIGINAL_APP_NAME_LOWER" "$file" 2>/dev/null; then
                APP_NAME_MATCHES=$(grep -o "$ORIGINAL_APP_NAME_LOWER" "$file" 2>/dev/null | wc -l | tr -d '[:space:]')
            fi
            
            PACKAGE_ID_MATCHES=0
            if grep -q "$ORIGINAL_PACKAGE_ID" "$file" 2>/dev/null; then
                PACKAGE_ID_MATCHES=$(grep -o "$ORIGINAL_PACKAGE_ID" "$file" 2>/dev/null | wc -l | tr -d '[:space:]')
            fi
            
            # Ensure we have clean integers
            APP_NAME_MATCHES=${APP_NAME_MATCHES:-0}
            APP_NAME_LOWER_MATCHES=${APP_NAME_LOWER_MATCHES:-0}
            PACKAGE_ID_MATCHES=${PACKAGE_ID_MATCHES:-0}
            
            # Convert to numbers
            APP_NAME_MATCHES=$((APP_NAME_MATCHES))
            APP_NAME_LOWER_MATCHES=$((APP_NAME_LOWER_MATCHES))
            PACKAGE_ID_MATCHES=$((PACKAGE_ID_MATCHES))
            
            if [ $APP_NAME_MATCHES -gt 0 ] || [ $APP_NAME_LOWER_MATCHES -gt 0 ] ||  [ $PACKAGE_ID_MATCHES -gt 0 ]; then
                if [ "$DRY_RUN" = true ]; then
                    REL_PATH=$(realpath --relative-to="$ROOT_DIR" "$file" 2>/dev/null || echo "$file")
                    echo -e "  Would modify: ${YELLOW}$REL_PATH${NC}"
                    if [ $APP_NAME_MATCHES -gt 0 ]; then
                        echo -e "    - Replace $APP_NAME_MATCHES occurrences of app name"
                    fi
                    if [ $APP_NAME_LOWER_MATCHES -gt 0 ]; then
                        echo -e "    - Replace $APP_NAME_LOWER_MATCHES occurrences of app name (lowercase)"
                    fi
                    if [ $PACKAGE_ID_MATCHES -gt 0 ]; then
                        echo -e "    - Replace $PACKAGE_ID_MATCHES occurrences of package ID"
                    fi
                else
                    # Replace content in the file
                    sed -i.bak "s/$ORIGINAL_APP_NAME/$NEW_APP_NAME/g" "$file"
                    sed -i.bak "s/$ORIGINAL_APP_NAME_LOWER/$NEW_APP_NAME_LOWER/g" "$file"
                    sed -i.bak "s/$ORIGINAL_PACKAGE_ID/$NEW_PACKAGE_ID/g" "$file"
                    
                    # Remove backup files
                    if [ -f "$file.bak" ]; then
                        rm "$file.bak"
                    fi
                    
                    REL_PATH=$(realpath --relative-to="$ROOT_DIR" "$file" 2>/dev/null || echo "$file")
                    echo -e "  Modified: ${GREEN}$REL_PATH${NC}"
                fi
                
                # Update counters
                TOTAL_MODIFIED_FILES=$((TOTAL_MODIFIED_FILES + 1))
                TOTAL_APP_NAME_COUNT=$((TOTAL_APP_NAME_COUNT + APP_NAME_MATCHES))
                TOTAL_APP_NAME_COUNT=$((TOTAL_APP_NAME_COUNT + APP_NAME_LOWER_MATCHES))
                TOTAL_PACKAGE_ID_COUNT=$((TOTAL_PACKAGE_ID_COUNT + PACKAGE_ID_MATCHES))
            fi
        fi
    done
    
    # Summary message
    if [ "$DRY_RUN" = true ]; then

        echo -e "${YELLOW}Would modify approximately $TOTAL_MODIFIED_FILES files ($TOTAL_APP_NAME_COUNT app name references, $TOTAL_PACKAGE_ID_COUNT package ID references)${NC}"
    else
        echo -e "${GREEN}✓ Text replacement completed: Modified $TOTAL_MODIFIED_FILES files ($TOTAL_APP_NAME_COUNT app name references, $TOTAL_PACKAGE_ID_COUNT package ID references)${NC}"
    fi
}

# Function to rename package directories
rename_package_directories() {
    echo -e "${BLUE}Restructuring package directories...${NC}"
    
    # List of source directories to update
    SRC_DIRS=(
        "composeApp/src/androidMain/kotlin"
        "composeApp/src/iosMain/kotlin"
        "composeApp/src/commonMain/kotlin"
    )
    
    for dir in "${SRC_DIRS[@]}"; do
        if [ -d "$ROOT_DIR/$dir/$ORIGINAL_PACKAGE_PATH" ]; then
            # Count files for summary
            FILE_COUNT=$(find "$ROOT_DIR/$dir/$ORIGINAL_PACKAGE_PATH" -type f | wc -l | tr -d '[:space:]')
            FILE_COUNT=${FILE_COUNT:-0}
            
            if [ "$DRY_RUN" = true ]; then
                echo -e "${YELLOW}Would move $FILE_COUNT files from:${NC}"
                echo -e "  $dir/$ORIGINAL_PACKAGE_PATH → $dir/$NEW_PACKAGE_PATH"
            else
                # Create new package directory structure
                mkdir -p "$ROOT_DIR/$dir/$NEW_PACKAGE_PATH"
                
                # Move files from old to new package directory
                mv "$ROOT_DIR/$dir/$ORIGINAL_PACKAGE_PATH"/* "$ROOT_DIR/$dir/$NEW_PACKAGE_PATH/" 2>/dev/null || true
                
                # Remove old package directory structure (empty directories)
                find "$ROOT_DIR/$dir/com" -type d -empty -delete 2>/dev/null || true
                
                echo -e "${GREEN}✓ Updated package structure in $dir${NC}"
                echo -e "  Moved $FILE_COUNT files to new package structure"
            fi
        else
            echo -e "${YELLOW}Warning: Directory $dir/$ORIGINAL_PACKAGE_PATH not found${NC}"
        fi
    done
}

# Main execution
replace_in_files
rename_package_directories

if [ "$DRY_RUN" = true ]; then
    echo -e "\n${YELLOW}DRY RUN COMPLETED${NC}"
    echo -e "${YELLOW}No changes were made. Run without --dry-run to apply changes.${NC}"
else
    echo -e "\n${GREEN}KMP Template personalization completed successfully!${NC}"
    echo -e "${BLUE}Your application has been personalized with:${NC}"
    echo -e "  - Application Name: ${GREEN}$NEW_APP_NAME${NC}"
    echo -e "  - Package ID: ${GREEN}$NEW_PACKAGE_ID${NC}"
    echo -e "\n${YELLOW}Note: You may need to refresh/reload your project in your IDE.${NC}"
fi
