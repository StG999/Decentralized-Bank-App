import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import Float "mo:base/Float";

actor DBank {
  // var CREATES MUTABLE VARIABLES. // THE KEYWORD stable PROVIDES orthogonal persistence TO THE VARIABLE. ie, IT DOES NOT LOSE STATE AFTER REDEPLOYING THE CANNISTER
  // THIS ABILITY OF MOTOKO MAKES IT UNIQUE.
  stable var currentValue : Float = 300; // ^^^^^
  // currentValue := 300; // ONLY TO RESET THE BALANCE. CAN BE USED WHEN WE WANT TO START THE ACCOUNT FROM BEGINNING.

  // currentValue := 100; // ASSIGNMENT OPERATOR -> :=

  let id = 12312981937123; // let WORKS LIKE const DOES. IT CREATES IMMUTABLE VARIABLES.

  Debug.print("-------------------------------");
  stable var startTime = Time.now();
  // startTime := Time.now(); // USED TO RESET THE SYSTEM. JUST LIKE THE ASSIGNMENT OF currentValue A FEW LINES ABOVE.
  Debug.print("currTime: ");
  Debug.print(debug_show (startTime));

  Debug.print("id: ");
  Debug.print(debug_show (id)); // Debug.print() TAKES IN ONLY text INPUTS. MUST USE debug_show() TO PRINT OTHER DATA TYPES.

  public func topUp(amount : Float) : async Float {
    currentValue += amount;
    Debug.print("currVal: ");
    Debug.print(debug_show (currentValue));
    let retVal = await checkBalance();
    return retVal;
  };

  public func withdraw(amount : Float) : async Float {
    if (amount <= currentValue) {
      currentValue -= amount;
      Debug.print("currVal: ");
      Debug.print(debug_show (currentValue));
    } else {
      Debug.print("a/c balance cannot go -ve.");
    };
    let retVal = await checkBalance();
    return retVal;
  };

  public query func checkBalance() : async Float {
    return currentValue;
  };

  public func compound() {
    let currentTime = Time.now();
    let timeElapsedNS = currentTime - startTime;
    let timeElapsedS = timeElapsedNS / Float.toInt(1e9);

    currentValue := currentValue * (1.001 ** Float.fromInt(timeElapsedS));

    startTime := currentTime;
  };

  // topUp();
};
