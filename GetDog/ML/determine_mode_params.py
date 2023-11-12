# Junhui Zhang

import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error
from sklearn.model_selection import cross_val_score
import joblib

# Load data
data = pd.read_csv('step_data.csv')

# Preprocessing: Feature engineering
data['Date'] = pd.to_datetime(data['Date'])
data['Day_of_Week'] = data['Date'].dt.dayofweek
# Other feature engineering steps...

# Assume features (X) and target variable (y)
X = data[['Day_of_Week', 'Degrees', 'Last_Week_Average_Steps']]
y = data['Steps']

# Split data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

best_score = float('-inf')
best_params = {}

# Define lists of n_estimators and random_states to iterate through
n_estimators_list = range(50, 500, 25)  # Define your range of n_estimators

for n_estimators in n_estimators_list:
        # Initialize the RandomForestRegressor with the current parameters
    rf = RandomForestRegressor(n_estimators=n_estimators, random_state=42)

    # Perform cross-validation
    scores = cross_val_score(rf, X, y, scoring='r2', cv=5)  # Assuming X and y are your data

    # Calculate the mean R2 score
    mean_r2 = scores.mean()

    # Print or store the results
    print(f"n_estimators: {n_estimators}, Mean R2 Score: {mean_r2}")

    # Check if the current parameters give a better score
    if mean_r2 > best_score:
        best_score = mean_r2
        best_params = {'n_estimators': n_estimators}

# Print the best parameters and best mean R2 score
print("\nBest Parameters:")
print(best_params)
print("Best Mean R2 Score:", best_score)

# Train the model with the best parameters
best_model = RandomForestRegressor(n_estimators=best_params['n_estimators'])
best_model.fit(X_train, y_train)

# Make predictions on test data using the best model
best_predictions = best_model.predict(X_test)

# Evaluate model performance
best_mse = mean_squared_error(y_test, best_predictions)
print(f"Mean Squared Error with Best Model: {best_mse}")

# Make predictions on the entire dataset using the best model
data['Best_Predictions'] = best_model.predict(X)  # Adding predictions to the original dataset

# Save predictions to a new CSV file
data.to_csv('step_data_with_best_predictions.csv', index=False)

# After training, save the best model
joblib.dump(best_model, 'best_random_forest_model.pkl')
