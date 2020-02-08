#!/bin/bash

################################################################
# Sript matches trades to their orders, produces a report and 
# outputs the total volume and turnover, per client.
# Created by: Joe Strain
################################################################

################################################################
# Fuction to get array index of supplied value           
# Usage: get_index $value "${array[@]}"                         
################################################################
get_index () {
	local valu="$1"
	shift
	local arr1=("$@")

	for j in "${!arr1[@]}"
	do
		if [[ "${arr1[$j]}" = "$valu" ]]
		then
			index="${j}";
		fi
	done
	return $index
}
################################################################


# Remove comments and create client and order arrays
grep -o '^[^#]*' example_orders.txt > orders.txt 
grep -o '^[^#]*' example_trades.txt > trades.txt 
arclientid=( $(cut -d ',' -f2 orders.txt ) )
arorderid=( $(cut -d ',' -f4 orders.txt ) )

# Set client totals and turnover to zero
aing_total=0; aing_turn=0
bank_total=0; bank_turn=0
grou_total=0; grou_turn=0
mega_total=0; mega_turn=0
trad_total=0; trad_turn=0

# Print headers of main report
echo "ClientID,OrderID,Price,Volume"

# Read in the trades one by one, find the corresponding client order
# Output the client id, order id, price, volume for each trade
# Also sum total volume and turnover, on a per client basis
while IFS= read -r line
do
	var=$(echo $line)
	timestamp=${var:0:8}
	orderid=${var:8:14}
	price=${var:23:8}
	volume=${var:31:8}
	
	# Array index of current Order ID, use to find Client ID
	get_index $orderid "${arorderid[@]}" 
	ind="$?"
	clientid="${arclientid["$ind"]}"
	
	# Print main report stats for current order ID
	echo "$clientid,$orderid,$price,$volume"

	# Remove zeros and calc turnover
	new_price=$(echo $price | sed 's/^0*//')
	new_volume=$(echo $volume | sed 's/^0*//')
	turnover=$(($new_price*$new_volume))

	# Add to the client totals
	case $clientid in
		AING)
			aing_total=$(($aing_total+$new_volume))
			aing_turn=$(($aing_turn+$turnover))
			;;
		BANK)
			bank_total=$(($bank_total+$new_volume))
			bank_turn=$(($bank_turn+$turnover))
			;;
		GROU)
			grou_total=$(($grou_total+$new_volume))
			grou_turn=$(($grou_turn+$turnover))
			;;
		MEGA)
			mega_total=$(($mega_total+$new_volume))
			mega_turn=$(($mega_turn+$turnover))
			;;
		TRAD)
			trad_total=$(($trad_total+$new_volume))
			trad_turn=$(($trad_turn+$turnover))
			;;	
		*)
			echo "Unknown Client ID"
			;;
	esac

done < trades.txt

# Print client summary report
echo "..."
echo "ClientID,Volume,Turnover"
echo "AING,$aing_total,$aing_turn"
echo "BANK,$bank_total,$bank_turn"
echo "GROU,$grou_total,$grou_turn"
echo "MEGA,$mega_total,$mega_turn"
echo "TRAD,$trad_total,$trad_turn"
