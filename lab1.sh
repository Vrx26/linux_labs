mkdir ~/test #1
cd ~/test

ls -Fa /etc > list #2

find /etc -maxdepth 1 -type d | wc -l >> list #3
find /etc -maxdepth 1 -type f -name ".*" | wc -l >> list

mkdir links #4

ln list links/list_hlink #5

ln -s ~/test/list ~/test/links/list_slink #6

echo "list: " && find . -samefile list | wc -l #7
echo "list_hlink: " && find . -samefile links/list_hlink | wc -l
echo "list_slink: " && find . -samefile links/list_slink | wc -l

cat list | wc -l >> links/list_hlink #8

cmp -s links/list_hlink links/list_slink && echo "before renaming: YES" #9

mv list list1 #10

cmp -s links/list_hlink links/list_slink && echo "after renaming: YES" #11

cd ~ #12
ln test/list1 list_link

find /etc -name '*.conf' -type f 2> /dev/null > list_conf #13

find /etc -name '*.d' -type d 2> /dev/null > list_d #14

cat list_conf > list_conf_d && cat list_d >> list_conf_d #15

mkdir test/.sub #16

cp list_conf_d test/.sub #17

cp -b list_conf_d test/.sub #18

ls -aR #19

man man > man.txt #20

split -b 1024 -d man.txt split-man- #21

mkdir man.dir #22

mv split-man-* man.dir/ #23

cat man.dir/split-man-* > man.dir/man.txt #24

cmp -s man.txt man.dir/man.txt && echo "man files: YES" #25

{ echo "starting text"; cat man.txt; } > man.txt.new \
&& mv man.txt.new man.txt \
&& echo "ending text" >> man.txt #26

diff man.txt  man.dir/man.txt > patch #27

mv patch man.dir/ #28

patch man.dir/man.txt man.dir/patch #29

cmp -s man.txt man.dir/man.txt && echo "after patch: YES" #30
