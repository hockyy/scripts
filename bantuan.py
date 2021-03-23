import os

def main():
    with open("bantuan.txt", 'r') as bantuan:
        stream = bantuan.read().split()
        for i in range(len(stream)):
            if(stream[i] == 'ZCZC'):
                if(i + 8 >= len(stream)): exit()
                quizData = stream[i:i+8]
                if(quizData[0] != 'ZCZC'): continue
                if(quizData[1] != 'W04'): continue
                if(quizData[2] != 'Q01'): continue
                if(quizData[4] != 'ssh-rsa'): continue
                if(quizData[-1] != 'NNNN'): continue
                username = quizData[3]
                if(not quizData[6].startswith(username)): continue
                sshdata = f"{quizData[4]} {quizData[5]} {quizData[6]}"
                print(f"{username} has valid data!")
                if(not os.path.isdir("ssh")):
                    os.mkdir("ssh")
                with open(f"ssh/{username}.pub", "w") as pubkey:
                    print(sshdata, file=pubkey)



if __name__ == '__main__':
    main()