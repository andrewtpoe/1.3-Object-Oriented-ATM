# The User class describes an account holder.
class User
  attr_accessor :name
  attr_accessor :pin
  attr_accessor :balance

  def initialize
    self.name = ""
    self.pin = ""
    self.balance = 0
  end

  # Verify that the user can withdraw the requested amount
  def can_withdraw?(amount)
    if self.balance >= amount
      return true
   else
      return false
   end
  end

  # Update the balance
  def deduct(amount)
    self.balance -= amount
  end

end



# Account information would probably get loaded from a database in a more "real world"
# application, but for now my database will consist of a array of user classes. I'll set that up here.
andrew = User.new
andrew.name = "andrew"
andrew.pin = "1234"
andrew.balance = 1000

bob = User.new
bob.name = "bob"
bob.pin = "4321"
bob.balance = 50

charles = User.new
charles.name = "charles"
charles.pin = "9876"
charles.balance = 50000

account_holders = [ andrew, bob, charles ]



# The machine class provides the information on the actual ATM
class Machine
  attr_accessor :balance

  # Verify that the ATM contains sufficient money for the withdrawal
  def can_withdraw?(amount)
    if self.balance >= amount
      return true
   else
      return false
   end
  end

  # Update the balance 
  def deduct(amount)
    self.balance -= amount
  end

end

# OK, lets initialize this ATM with a $10,000 balance
atm = Machine.new
atm.balance = 10000



# The program class provides the actual functionality of the program.
class Program 

  attr_accessor :exit_prog
  attr_accessor :is_valid
  attr_accessor :usr_name
  attr_accessor :usr_pin
  attr_accessor :main_menu_sel
  attr_accessor :acc_menu_sel

  def initialize(machine, account_holders)
    @atm = machine
    @account_holders = account_holders
    self.exit_prog = false
    self.is_valid = false
    self.main_menu_sel = 0
    self.acc_menu_sel = 0
  end

  # This is the main loop that is called to run the program.
  def run
    # Reset defaults to prevent odditties
    self.is_valid = false
    self.main_menu_sel = 0
    self.acc_menu_sel = 0

    # Display the main menu and get the users input
    main_menu_sel = self.main_menu

    # Verify the main_menu_sel is a valid input, proceed only if able.
    if (1..3).include?(main_menu_sel)
      main_men_sel_valid = true
      while main_men_sel_valid == true
        case main_menu_sel
        when 1
          # First, lets get the user's login information
          # This will return a hash with the user's name and pin
          display_acc_menu = false
          login = self.get_login_info

          # Next let's try to verify that information and determine our course of action.
          index = 0
          ver_user = 0
          @account_holders.each do |user|
            if user.name == login[:name] && user.pin == login[:pin]
              puts "Your account has been verified."
              puts ""
              display_acc_menu = true
              ver_user = index
            end
            index += 1
          end

          # For easier access later on, let's identify which user we have verified.
          user = @account_holders[ver_user]

          # OK, the user has been validated and should be given the account menu.
          if display_acc_menu == true
            while display_acc_menu == true
              acc_menu_sel = self.account_menu

              # Verify the acc_menu_sel is a valid input, proceed only if able
              if (1..3).include?(acc_menu_sel)
                case acc_menu_sel
                when 1
                  # The user would like to view their available balance
                  puts "Your current account balance is: $#{user.balance}"
                  puts ""
                when 2
                  # The user would like to withdraw from their account
                  print "How much would you like to withdraw? $"
                  amount = gets.chomp.to_i
                  puts ""
                  # Let's make sure the account and the ATM can handle this transaction
                  if user.can_withdraw?(amount) && @atm.can_withdraw?(amount)
                    puts "Dispensing cash..." 
                    user.deduct(amount)
                    @atm.deduct(amount)
                    puts "Your new balance is $#{user.balance}"
                    puts "Thank you for paying that enourmous fee."
                    puts ""
                  elsif user.can_withdraw?(amount) == false
                    puts "You have asked to withdraw more than you have in your account"
                    puts ""
                  elsif @atm.can_withdraw?(amount) == false
                    puts "ATM has insufficient balance to fulfill this request."
                    puts ""
                  else
                    puts "Something went wrong, and I don't know what"
                    puts ""
                  end
                # The user would like to exit their account.  
                else
                  puts "Now exiting to the main menu."
                  puts ""
                  display_acc_menu = false
                  main_men_sel_valid = false
                end
              # Invalid input in the account menu. Log out for security
              else
                puts "This was not a valid menu input."
                puts "Logging you out for security purposes."
                puts ""
                display_acc_menu = false
                main_men_sel_valid = false
              end
            end
          # Login did not match records. 
          else
            puts "Your login does not match our records."
            puts "Please try loggin in again."
            puts ""
            main_men_sel_valid = false
          end
          
        when 2
          # This code should view the atm's current balance
          puts "This ATM currently has $#{@atm.balance}"
          puts ""
          main_men_sel_valid = false
        
        else
          # The user would like to exit the program entirely.
          puts "Now exiting the ATM program. Goobye."
          puts ""
          main_men_sel_valid = false
          self.exit_prog = true
        end
      end
    # Invalid input in the main menu. Request another attempt.  
    else
      puts "Your input was invalid. Please try again."
      puts ""
    end 
  end

  # Displays the main menu and returns the user's selection
  def main_menu
    puts "What would you like to do?"
    puts ""
    puts "  1: Enter your account information"
    puts "  2: View the ATM's cash balance"
    puts "  3: Shut down this ATM"
    puts ""
    print "Please enter your selection: "
    main_menu_sel = gets.chomp.to_i
    puts ""
    return main_menu_sel
  end

  # Gathers the user's login and pin information
  def get_login_info
    print "Please enter your name: "
    name = gets.chomp
    puts ""
    print "Please enter your pin number: "
    pin = gets.chomp
    puts ""
    login = { name: name, pin: pin}
    return login
  end

  # Displays the account menu and returns the user's selection
  def account_menu
    puts "What would you like to do?"
    puts ""
    puts "1: Check your balance"
    puts "2: Withdraw funds" 
    puts "3: Exit to Main Menu"
    puts ""
    print "Please enter your selection: "
    acc_menu_sel = gets.chomp.to_i
    puts ""
    return acc_menu_sel
  end

# Closes the class
end


# This line creates a new instance of the Program.
program = Program.new(atm, account_holders)

# This executes the program until the user has decided to exit.
while program.exit_prog == false
  program.run
end














































