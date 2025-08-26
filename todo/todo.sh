#!/bin/bash
DB="$HOME/.todos.db"

usage() {
    echo "Usage:"
    echo "  todo add <category> <date YYYY-MM-DD> <task...>"
    echo "  todo list [all|todo|category <name>]"
    echo "  todo done <task-id>"
    echo "  todo next [i]"
    echo "  reorder"
    exit 1
}

cmd="$1"
shift || true

DIM="\e[2;37;m"
RESET="\e[22;37;m"
WHITE="\e[0;37;m"
RED="\e[1;31;m"
GREEN="\e[1;32;m"
BLUE="\e[1;34;m"

format_todo() {
    IFS='|' read -r category task date id status <<< "$1"
    if [[ "$status" == "DONE" ]]; then
        DATE_OR_DONE="(${RESET}${BLUE}DONE${DIM})"

    else
        DATE_OR_DONE="(${RESET}${RED}due $date${DIM})"
    fi

    echo -e "${DIM}$id. [${RESET}${GREEN}$category${DIM}] ${RESET}${WHITE}$task ${DIM}$DATE_OR_DONE${RESET}"

}

next_id() {
    if [[ ! -s "$DB" ]]; then
        echo "001"
    else
        max=$(cut -d'|' -f4 "$DB" | sort -n | tail -n1)
        printf "%03d" $((10#$max + 1))
    fi
}

case "$cmd" in
    add)
        if [[ $# -lt 3 ]]; then usage; fi
        category="$1"
        date="$2"
        shift 2
        task="$*"
        id=$(next_id)
        echo "$category|$task|$date|$id|TODO" >> "$DB"
        echo "Added: $category|$task|$date|$id|TODO"
        ;;

    list)
        mode="${1:-all}"
        filter="$2"
        case "$mode" in
            all)
                nl -w2 -s'. ' "$DB" | while read -r num line; do
                    format_todo "$line"
                done
                ;;
            todo)
                grep '|TODO$' "$DB" | nl -w2 -s'. ' | while read -r num line; do
                    format_todo "$line"
                done
                ;;
            category)
                [[ -n "$filter" ]] || usage
                grep "^$filter|" "$DB" | nl -w2 -s'. ' | while read -r num line; do
                    format_todo "$line"
                done
                ;;
            *) usage ;;
        esac
        ;;

    done)
        [[ $# -lt 1 ]] && usage
        target_id="$1"

        awk -F'|' -v id="$target_id" 'BEGIN{OFS="|"}
        {
            if ($4 == id && $5 == "TODO") {
                $5 = "DONE"
                print $0 > "/dev/stderr"
            }
            print $0
        }' "$DB" 2> >(while read -r updated; do
            echo "Marked done: $(format_todo "$updated")"
        done) > "$DB.tmp" && mv "$DB.tmp" "$DB"
        ;;

    next)
        index="${1:-1}"
        line=$(grep '|TODO$' "$DB" | sort -t'|' -k3 | sed -n "${index}p")

        if [[ -z "$line" ]]; then
            exit 1
        fi

        format_todo "$line"
        ;;

    reorder)
        tmpfile=$(mktemp)
        awk -F'|' '$5 == "TODO"' "$DB" | sort -t'|' -k3 >> "$tmpfile"
        awk -F'|' '$5 == "DONE"' "$DB" | sort -t'|' -k3 >> "$tmpfile"
        mv "$tmpfile" "$DB"
        ;;

    ""|help|--help|-h)
        usage
        ;;

    *)
        echo "Unknown command: $cmd"
        usage
        ;;
esac
