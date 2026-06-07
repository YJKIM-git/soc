set prj_name "aes128"
set prj_dir "./$prj_name"
create_project $prj_name $prj_dir -force
#set_property board_part digilentinc.com:zybo-z7-20:part0:1.2 [current_project]
#set_property part xc7z020clg400-1 [current_project]

# filelist.f를 읽어 순서대로 파일을 sources_1에 추가
set fp [open "filelist.f" r]
while {[gets $fp line] >= 0} {
    # 빈 줄이나 주석(#) 건너뛰기
    set line [string trim $line]
    if {$line == "" || [string match "#*" $line]} { continue }
    
    # 파일 경로를 명시적으로 추가
    add_files -fileset sources_1 $line
}
close $fp

set_property top aes_core [current_fileset]

# tb 디렉토리 파일 추가
set tb_files [glob -directory "tb" *.v]
add_files -fileset sim_1 $tb_files
set_property top tb_aes [get_filesets sim_1]

# 컴파일 순서 고정 (파일 리스트에 명시된 순서 보존)
set_property source_mgmt_mode DisplayOnly [current_project]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

puts "프로젝트 생성 완료: $prj_name (filelist.f 순서 반영됨)"