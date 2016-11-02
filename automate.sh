#This script is used to auto resize and add watermark on images and save them to diffrent folders

while true;
do 
	#clear
	source ./confg.ini
	if [ ! -d $camera_folder ]; then mkdir $camera_folder; fi
	for i in $camera_folder*.jpg
	do
		if [ ! -d $print_folder ]; then mkdir $print_folder; fi
		if [ ! -d $source_folder ]; then mkdir $source_folder; fi
		if [ ! -d "./semiprocessed" ]; then mkdir "./semiprocessed"; fi
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
			"./semiprocessed/$filename";
			
			if [ ! -d "./org_images" ]; then mkdir "./org_images"; fi
			mv -f "$camera_folder$filename" "./org_images/$filename";

			if [ "$type" = "gif" ]; then
				numfiles=(./semiprocessed/*jpg)
				numfiles=${#numfiles[@]}
				
				if [ $numfiles = $frames ]; then
					gif_filename=$(basename "$i" .jpg)
					echo "creating gif $gif_filename";
					
					./lib/convert -delay $frame_delay -loop 0 "./semiprocessed/*jpg" "$source_folder$gif_filename.gif";
					
					rm -rf ./semiprocessed/*
				fi
			else
				mv -f "./semiprocessed/$filename" "$source_folder$filename";
			fi

			echo $filename;
		else
			echo "NO FILES"
		fi
	done
sleep 2
done
done