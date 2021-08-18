
f=open('/Users/stbates/Desktop/ansible/cisco/txt.txt')
lines=f.readlines()
ad_id = (lines[0][60:96]) 


with open('/Users/stbates/Desktop/ansible/cisco/secrets.yml') as f:
    if 'ise_id' in f.read():
        print("true")
    else:
        with open("/Users/stbates/Desktop/ansible/cisco/secrets.yml", "a") as text_file:  
            print("ise_id: " + ad_id, file=text_file)
