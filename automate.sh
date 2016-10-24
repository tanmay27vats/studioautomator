#This script is used to auto resize and add watermark on images and save them to diffrent folders

#while true;
#do 
	clear
	source automat.confg
	for i in ./camera/*.jpg ./camera/*.jpeg;
	do
		if [ ! -d $print_folder ]; then mkdir $print_folder; fi
		if [ ! -d $source_folder ]; then mkdir $source_folder; fi
		filename=$(basename "$i")
		if [ -f "$i" ];
		then
			#./lib/convert \
			#-filter Lanczos \
			#"$i" \
			#-set option:filter:filter Lanczos \
			#-set option:filter:blur 0.8 \
			#-resize 1800x1200 \
			#-quality 90 \
			#./watermark/watermark.png -gravity SouthEast -geometry +30 -composite \
			#"./print/$filename";

			./lib/convert \
			"$i" \
			-set option:filter:filter Lanczos \
			-resize $print_width'x'$print_height \
			-quality 90 \
			$print_overlay -gravity center -composite \
			"$print_folder$filename";
			
			./lib/convert \
			"$i" \
			-set option:filter:filter Lanczos \
			-resize $source_width'x'$source_height \
			-quality 90 \
			$source_overlay -gravity center -composite \
			"$source_folder$filename";

			#mv $i "./images/$filename";
			echo $filename;
		else
			echo "NO FILES"
		fi
	done
#sleep 2
#done
#done