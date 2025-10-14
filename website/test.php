<?php

echo "<h1>Jenkins CI/CD Pipeline Trigger Test</h1>";
echo "<p>Branch: " . getenv('BRANCH_NAME') . "</p>";
echo "<p>Server: " . gethostname() . "</p>";

//  timestamp so every commit is different
echo "<p>Build Trigger Time: " . date('Y-m-d H:i:s') . "</p>";


