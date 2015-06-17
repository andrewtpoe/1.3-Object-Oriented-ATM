# Create a little ATM

# person's information/account => 
#   name
#   pin number
# how much money do they want?
# check your balance
# how much money is in the account
# what time did the transaction occur
# what time did the transaction ovver
# how much money is actually in this ATM Machine?
# dialy limit

# Expectations:
# Enter name:
# Enter pin:
# Actions:
#   Check my balance
# =>Withdraw funds
#   Canel all the things

# if name and pin do not match, exit.

# if check balance, return what the balance is

# if withdraw funds
#   make sure ATM has enough money for the withdrawal
#   check withdrawal request vs. balance to make sure you have enough funds
#   if all good.
#     dispense the cash
#     update and display the account balance
#     thank them for the fee and exit.

account_data = { :name => 'Andrew', :balance => 4000, :pin => 1234 }
atm_balance = { :cash => 10000 }

puts "Welcome to ATM 8675309" 
puts "Please enter your name"
print ">> "
name = gets.chomp
puts "Please enter your pin number."
print ">> "
pin = gets.chomp.to_i

if name == account_data[:name] && pin == account_data[:pin]

  menu_LCV = 1
  while menu_LCV == 1

    puts "\nWhat would you like to do?\n\n1: Check your balance\n2: Withdraw funds\n3: Exit\n\n"

    print ">> "
    men_sel = gets.chomp

    valid_options = ['1', '2', '3']
    if valid_options.include?(men_sel)
      case men_sel
      when '1'
        puts "Your account balance is : $#{account_data[:balance]}\n"
      when '2'
        puts "How much would you like to withdraw?"
        print ">> "
        amount = gets.chomp.to_i
        if amount <= account_data[:balance] && amount <= atm_balance[:cash]
          puts "Dispensing cash..." 
          account_data[:balance] = account_data[:balance] -= amount
          atm_balance[:cash] = atm_balance[:cash] -= amount
          puts "Your new balance is #{account_data[:balance]}"
          puts "Thank you for paying that enourmous fee.\n"
        elsif amount >= account_data[:balance]
          puts "You have asked to withdraw more than you have in your account"
        elsif amount >= atm_balance[:cash]
          puts "ATM has insufficient balance to fulfill this request."
        else
          puts "Something went wrong."
        end
      else
        puts "Exiting the program."
        menu_LCV = 0
      end
    else
      puts "I'm sorry, that was not a valid input."
      puts "The self detonation sequence has begun."
      puts "You should run..."
      menu_LCV = 0
    end
  end

else
  puts "I'm sorry, you do not have an account at this bank."
  puts "Now exiting..."
end
