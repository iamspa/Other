#!/bin/bash
    # Automatically Updates System Time According to the NIST Atomic Clock in a Linux Environment
    # Credit To Syifa Saif Hidayat Link https://www.youtube.com/watch?v=h1eyHaE-lXg
    nistTime=$(curl -I --insecure 'time.windows.com' | grep "ate:")
    echo $nistTime
    dateString=$(echo $nistTime | cut -d' ' -f2-7)
    dayString=$(echo $nistTime | cut -d' ' -f2-2)
    dateValue=$(echo $nistTime | cut -d' ' -f3-3)
    monthValue=$(echo $nistTime | cut -d' ' -f4-4)
    yearValue=$(echo $nistTime | cut -d' ' -f5-5)
    timeValue=$(echo $nistTime | cut -d' ' -f6-6)
    timeZoneValue=$(echo $nistTime | cut -d' ' -f7-7)
    #echo $dateString
    case $monthValue in
        "Jan")
            monthValue="01"
            ;;
        "Feb")
            monthValue="02"
            ;;
        "Mar")
            monthValue="03"
            ;;
        "Apr")
            monthValue="04"
            ;;
        "May")
            monthValue="05"
            ;;
        "Jun")
            monthValue="06"
            ;;
        "Jul")
            monthValue="07"
            ;;
        "Aug")
            monthValue="08"
            ;;
        "Sep")
            monthValue="09"
            ;;
        "Oct")
            monthValue="10"
            ;;
        "Nov")
            monthValue="11"
            ;;
        "Dec")
            monthValue="12"
            ;;
        *)
            continue
    esac
    date --utc --set $yearValue.$monthValue.$dateValue-$timeValue
