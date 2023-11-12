import coremltools as cml
import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error
import joblib
from sklearn import tree

data = pd.read_csv("step_data.csv")
data["date"] = pd.to_datetime(data["date"])
data["dayOfWeek"] = data["date"].dt.dayofweek
X = data[["dayOfWeek", "degrees", "lastWeekAverageSteps", "gender", "age", "weight", "height"]]
y = data["steps"]
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

RFR = RandomForestRegressor(n_estimators=500, random_state=42)
RFR.fit(X_train, y_train)

predictions = RFR.predict(X_test)
mse = mean_squared_error(y_test, predictions)
print(f"Mean Squared Error: {mse}")
data["Predictions"] = RFR.predict(X)

data.to_csv("step_data_with_predictions.csv", index=False)
joblib.dump(RFR, "random_forest_model.pkl")

model = cml.converters.sklearn.convert(RFR, ["dayOfWeek", "degrees", "lastWeekAverageSteps", "gender", "age", "weight", "height"], "steps")
model.author = "Junhui"
model.license = "AALTO"

model.save("StepsPrediction.mlmodel")
