from enum import Enum

def find_last_instance(lst, element):
    for i in range(len(lst) - 1, -1, -1):
        if lst[i] == element:
            return i
    return -1


class Operators(Enum):
    plus = '+'
    minus = '-'
    mul = '*'
    div = '/'

NUMBERS = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
SYMBOLS = ['+', '-', '*', '/']
PARA = ['(', ')']
exepression = input("Enter exepression")

exepression = exepression.replace(" ", "")

EXEPR = exepression

ALL_VALID = NUMBERS + SYMBOLS + PARA

class Action:
    def calc(self, first, oper, second):
        if oper == '+':
            return str(self.add(int(first), int(second)))
        elif oper == '-':
            return str(self.sub(int(first), int(second)))
        elif oper == '*':
            return str(self.mul(int(first), int(second)))
        elif oper == '/':
            return str(self.div(int(first), int(second)))
    def add(self, first, second):
        return first + second

    def sub(self, first, second):
        return first - second

    def mul(self, first, second):
        return first * second

    def div(self, first, second):
        return int(first / second)




class Orgenize(Action):
    def __init__(self, exepr):
        Action.__init__(self)
        self.exepr = exepr
        self.start_minus = False
        self.orgenize = []
        self.initExep()
        self.orgeni()
        self.orgenOper()
        if self.orgenize[-1] in SYMBOLS:
            raise ValueError("Last is oper")






    def orgenOper(self):
        for x in range(len(self.orgenize)-1):
            if(self.orgenize[x] == '+' and self.orgenize[x+1] == '+'):
                del self.orgenize[x]
                break
            elif (self.orgenize[x] == '-' and self.orgenize[x + 1] == '+'):
                del self.orgenize[x+1]
                break
            elif (self.orgenize[x] == '+' and self.orgenize[x + 1] == '-'):
                del self.orgenize[x]
                break
            elif (self.orgenize[x] == '-' and self.orgenize[x + 1] == '-'):
                self.orgenize[x] = '+'
                del self.orgenize[x + 1]
                break
        for i in range(len(self.orgenize) -1):
            if (self.orgenize[i] in SYMBOLS and self.orgenize[i+1] in SYMBOLS):
                self.orgenOper()
                break

    def initExep(self):
        self.orgenize.append('0')
        if self.exepr[0] != '-':
            self.orgenize.append('+')
        else:
            self.start_minus = True

    def orgeni(self):
        st = ""
        for char in range(0, len(self.exepr)):
            if(self.exepr[char] in SYMBOLS or self.exepr[char] in PARA):
                if st != "":
                    self.orgenize.append(st)
                    st = ""
                if self.exepr[char] == '-':
                    if self.exepr[char-1] in SYMBOLS:
                        st += '-'
                    else:
                        self.orgenize.append(self.exepr[char])
                else:
                    self.orgenize.append(self.exepr[char])


            elif (self.exepr[char] in NUMBERS):
                st += self.exepr[char]
        if st in SYMBOLS:
            raise ValueError("Operator ar the end")
        if st != "":
            self.orgenize.append(st)

class Calculator(Orgenize):
    def __init__(self, expression):
        self.expression = expression
        Orgenize.__init__(self, expression)
        self.exep = self.orgenize
        self.result = 0
        self.temp = []
    def checkValid(self):
        for x in self.exepr:
            if x not in ALL_VALID:
                raise ValueError("Not valid char")
                exit()

    def handle_para(self):
        if self.exep.count('(') == 1 and self.exep.count(')') == 1:
            end = self.exep.index(')')
            start = self.exep.index('(') + 1
        else:
            end = self.exep.index(')')
            for index in range(end, 0, -1):
                if self.exep[index] == '(':
                    start = index+1
                    break

        new = self.exep[start:end]
        print(new)
        a = Calculator(''.join(new))
        a.calculate()
        result = a.result
        if start > 0:
            before = self.exep[:start - 1]
        else:
            before = self.exep[:start]
        if end < len(self.exep):
            after = self.exep[end+1:]
        else:
            after = self.exep[end:]


        new = before + [result] + after
        self.temp = new
        self.exep = self.temp
        if '(' in self.exep:
            self.handle_para()

    def calculate(self):
        if '(' in self.exep:
            self.handle_para()
            self.exep = self.temp


        if len(self.exep) == 1:
            print(f"1Result: {self.exep}")
            print("Here")
            exit(1)



        elif len(self.exep) == 3:
            result = self.calc(self.exep[0], self.exep[1], self.exep[2])
            if '(' not in EXEPR:
                print(f"2Result {result}")
                exit(1)
            self.result = result



        else:
            if '*' not in self.exep and '/' not in self.exep:
                result = self.calc(self.exep[0], self.exep[1], self.exep[2])
                self.exep = [result] + self.exep[3:]
                if '+' in self.exep or '-' in self.exep:
                    self.calculate()
            else:
                for num in range(len(self.exep) -1):
                    if self.exep[num] == '*' or self.exep[num] == '/':
                        result = self.calc(self.exep[num-1], self.exep[num], self.exep[num+1])
                        new = self.exep[:num-1] + [result]
                        if len(self.exep) == num+1:
                            new = new
                        else:
                            new += self.exep[num+2:]
                        if '+' in self.exep or '-' in self.exep or '*' in self.exep or '/' in self.exep:
                            self.exep = new
                            self.calculate()
                        break






a = Calculator(exepression)
a.checkValid()
a.calculate()
print(f"FINAL RESULT: {a.result}")
